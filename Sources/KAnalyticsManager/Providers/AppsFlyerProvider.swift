import Foundation

final class AppsFlyerProvider: AnalyticsProvider {
    let serviceType: AnalyticsServiceType = .appsflyer
    let eventMapper: AnalyticsEventMapper

    init(eventMapper: AnalyticsEventMapper) {
        self.eventMapper = eventMapper

        // AppsFlyer SDK 초기화
    }

    func logEvent(_ event: AnalyticsEvent) {
        let name = eventMapper.eventName(event)
        let parameters = eventMapper.eventParameter(event)
        print("---------------AppsFlyer--------------")
        print(name)
        print(parameters)
        print("-------------------------------------")
    }

    func setUserProperty(key: String, value: String?) {

    }

}
