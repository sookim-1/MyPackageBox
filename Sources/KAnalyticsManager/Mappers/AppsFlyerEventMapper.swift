import Foundation

final class AppsFlyerEventMapper: AnalyticsEventMapper {

    func userProperties(_ event: AnalyticsEvent, serviceType: AnalyticsServiceType) -> [String: String]? {
        return [:]
    }

    func eventName(_ event: AnalyticsEvent) -> String {
        if let loginEvent = event as? DemoLoginEvent {
            switch loginEvent {
            case .login: return "af_user_login"
            case .logout: return "af_user_logout"
            }
        } else if let screenEvent = event as? DemoScreenEvent {
            switch screenEvent {
            case .loginPage: return "af_login_page_viewed"
            }
        }


        print("변환하지 않는 이벤트?: \(type(of: event))")
        return event.name
    }

    func eventParameter(_ event: AnalyticsEvent) -> [String: Any] {
        var baseParameters = event.parameters

        // 모든 Hackle 이벤트에 공통 파라미터 예시
        baseParameters["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"

        if let loginEvent = event as? DemoLoginEvent {
            switch loginEvent {
            case let .login(success, type):
                baseParameters["is_successful_login"] = success
                baseParameters["login_type_method"] = type
            case .logout:
                break
            }
        } else if let screenEvent = event as? DemoScreenEvent {
            switch screenEvent {
            case .loginPage:
                baseParameters["screen_category"] = "authentication"
            }
        }

        // 기본값: 어떤 이벤트 타입도 해당하지 않으면, 원래 파라미터를 사용
        print("변환하지 않는 이벤트?: \(type(of: event))")
        return baseParameters
    }
}
