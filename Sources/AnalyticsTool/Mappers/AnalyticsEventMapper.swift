import Foundation

/// AnalyticsEventMapper : 이벤트 변환 필요한 경우 사용
protocol AnalyticsEventMapper {
    func eventName(_ event: AnalyticsEvent) -> String
    func eventParameter(_ event: AnalyticsEvent) -> [String : Any]
    func userProperties(_ event: AnalyticsEvent, serviceType: AnalyticsServiceType) -> [String: String]?
}
