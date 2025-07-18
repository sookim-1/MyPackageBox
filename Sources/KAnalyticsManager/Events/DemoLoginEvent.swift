import Foundation

enum DemoLoginEvent: AnalyticsEvent {

    case login(success: Bool, type: String)
    case logout

    var name: String {
        switch self {
        case .login:
            return "login"
        case .logout:
            return "logout"
        }
    }

    var parameters: [String : Any] {
        switch self {
        case let .login(success, type):
            return ["success": success, "type": type]
        case .logout:
            return [:]
        }
    }

    var targetServices: [AnalyticsServiceType] {
        switch self {
        case .login:
            return [.firebase, .appsflyer, .customInternal]
        case .logout:
            return [.firebase]
        }
    }

}

