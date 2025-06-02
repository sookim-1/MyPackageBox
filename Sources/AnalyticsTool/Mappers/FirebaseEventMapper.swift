import Foundation

final class FirebaseEventMapper: AnalyticsEventMapper {
    func userProperties(_ event: AnalyticsEvent, serviceType: AnalyticsServiceType) -> [String: String]? {
        return [:]
    }

    func eventName(_ event: AnalyticsEvent) -> String {
        return event.name
    }

    func eventParameter(_ event: AnalyticsEvent) -> [String : Any] {
        return event.parameters
    }
}
