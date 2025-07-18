import Foundation

/// AnalyticsEvent : Custom Event 추상화
protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any] { get }
    var userProperties: [String: String]? { get }

    var targetServices: [AnalyticsServiceType] { get }
}

extension AnalyticsEvent {
    var userProperties: [String: String]? { return nil }
}
