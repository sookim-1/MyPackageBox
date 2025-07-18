import Foundation

/// AnalyticsProvider : 분석도구 구현 단계
protocol AnalyticsProvider {
    var serviceType: AnalyticsServiceType { get }
    var eventMapper: AnalyticsEventMapper { get }

    func logEvent(_ event: AnalyticsEvent)
    func setUserProperty(key: String, value: String?)
}
