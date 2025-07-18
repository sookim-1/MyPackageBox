import Foundation

public actor KDataManager {

    // NSCache 인스턴스 사용해서 싱글톤
    static let shared = KDataManager()

    private init() {}

    // 범용 성 위해 Key, Value를 AnyObject로 선언
    private lazy var memCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        // totalCostLimit 기본값 0 (제한없음)이므로 100MB 설정
        cache.totalCostLimit = 100_000_000
        return cache
    }()

}

public extension KDataManager {

    enum ErrorType: Error {
        case noData
        case noFilePath
        case fileNotFound
    }

}

public extension KDataManager {

    enum DataLocationType {
        case cache
        case document

        public var directoryPath: URL? {
            switch self {
            case .cache:
                return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            case .document:
                return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            }
        }
    }
    
}

public extension KDataManager {

    /// 캐시에서 데이터를 로드합니다 (메모리 -> 디스크 순)
    func loadCache(locationType: DataLocationType, forKey key: String) -> Result<Data, Error> {
        let cacheKey = NSString(string: key)

        // 1. 메모리 캐시 확인
        if let cachedData = self.memCache.object(forKey: cacheKey) as? Data {
            return .success(cachedData)
        }

        guard let directoryPath = locationType.directoryPath else {
            return .failure(ErrorType.noFilePath)
        }

        return loadFile(directoryURL: directoryPath, forKey: key)
    }

    func saveCache(locationType: DataLocationType, data: Data, forKey key: String) {
        self.memCache.setObject(NSData(data: data), forKey: NSString(string: key))

        guard let directoryPath = locationType.directoryPath else {
            return
        }

        do {
            try self.saveFile(data: data, directoryURL: directoryPath, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }

}


public extension KDataManager {

    private func loadFile(directoryURL: URL, forKey key: String) -> Result<Data, Error> {
        let fileURL = directoryURL.appendingPathComponent(key.sanitizedFileName)

        guard let data = try? Data(contentsOf: fileURL) else {
            return .failure(ErrorType.fileNotFound)
        }

        // FIXME: 메모리 캐시 저장 -> 위치 변경
        self.memCache.setObject(NSData(data: data), forKey: NSString(string: key))

        return .success(data)
    }

    private func saveFile(data: Data, directoryURL: URL, forKey key: String) throws {
        let fileURL = directoryURL.appendingPathComponent(key.sanitizedFileName)

        try data.write(to: fileURL)
    }

}

