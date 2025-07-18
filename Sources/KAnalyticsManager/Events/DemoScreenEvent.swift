import Foundation

enum DemoScreenEvent: AnalyticsEvent {

    case loginPage

    var name: String {
        switch self {
        case .loginPage: return "loginPage"
        }
    }

    var parameters: [String : Any] {
        switch self {
        case .loginPage:
            return [:]
        }
    }

    var targetServices: [AnalyticsServiceType] {
        switch self {
        case .loginPage:
            return [.firebase]
        }
    }

}
