import Foundation

// MARK: - String Extension for File Name
public extension String {

    /// URL 등을 파일 이름으로 사용할 때 부적합한 문자를 제거합니다.
    var sanitizedFileName: String {
        return self.components(separatedBy: CharacterSet(charactersIn: ":/\\?%*|\"<>")).joined()
    }

}
