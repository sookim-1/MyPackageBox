import UIKit
import ImageIO

public class KImageLoader {

    public struct ImageData: Codable {
        let data: Data
        let url: String
        let eTag: String?
    }

    public enum ImageError: Error, Equatable {
        case invalidURL
        case notModified // 304
        case networkError
        case dataConversionFailed
    }

    public static func loadImage(with imageURLString: String, downsamplingTo pointSize: CGSize? = nil, scale: CGFloat = UIScreen.main.scale) async -> Result<UIImage, Error> {
        guard let imageURL = URL(string: imageURLString) else {
            return .failure(ImageError.invalidURL)
        }

        // --- 함수형 파이프라인 시작 ---
        let finalResult = await KDataManager.shared.loadCache(locationType: .cache, forKey: imageURLString)
            .decode(decoder: ImageData.self)
            .asyncFlatMap { cachedData in
                // 캐시 성공: ETag 검증
                return await validateCache(with: cachedData, for: imageURL)
            }
            .asyncFlatMapError { error in
                // 캐시 실패: 네트워크에서 새로 다운로드
                return await fetchFromNetwork(for: imageURL, withETag: nil)
            }
            .asyncMap { imageData in
                // 최종 성공: 다운샘플링 및 UIImage 변환
                return downsampleIfNeeded(data: imageData.data, to: pointSize, scale: scale)
            }

        return finalResult
    }

    private static func validateCache(with cachedData: ImageData, for url: URL) async -> Result<ImageData, Error> {
        let networkResult = await fetchFromNetwork(for: url, withETag: cachedData.eTag)

        switch networkResult {
        case .success(let freshData):
            print("ETag 동일하지 않음 새로운 데이터 변환")
            return .success(freshData) // 새 데이터 반환
        case .failure(let error as ImageError) where error == .notModified:
            print("ETag 동일")
            return .success(cachedData) // 캐시 데이터가 유효하므로 그대로 반환
        case .failure(let otherError):
            print("ETag 실패")
            return .failure(otherError) // 다른 에러는 그대로 전달
        }
    }

    private static func fetchFromNetwork(for url: URL, withETag eTag: String?) async -> Result<ImageData, Error> {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        if let eTag = eTag { request.setValue(eTag, forHTTPHeaderField: "If-None-Match") }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }

            if httpResponse.statusCode == 304 { throw ImageError.notModified }
            if !(200...299).contains(httpResponse.statusCode) { throw URLError(.badServerResponse) }

            let newETag = httpResponse.value(forHTTPHeaderField: "ETag")
            let imageData = ImageData(data: data, url: url.absoluteString, eTag: newETag)

            // 새로 받은 데이터는 캐시에 저장
            if let dataToCache = try? JSONEncoder().encode(imageData) {
                await KDataManager.shared.saveCache(locationType: .cache, data: dataToCache, forKey: url.absoluteString)
            }
            return .success(imageData)

        } catch {
            return .failure(error)
        }
    }

    private static func downsampleIfNeeded(data: Data, to pointSize: CGSize?, scale: CGFloat) -> UIImage {
        if let pointSize = pointSize,
            let downsampled = downsample(imageData: data, to: pointSize, scale: scale) {
            return downsampled
        }

        return UIImage(data: data) ?? UIImage()
    }

    private static func downsample(imageData: Data, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else {
            return nil
        }

        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale

        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary

        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }

        return UIImage(cgImage: downsampledImage)
    }

}
