import Foundation

final class FirebaseProvider: AnalyticsProvider {

    let serviceType: AnalyticsServiceType = .firebase
    let eventMapper: AnalyticsEventMapper

    init(eventMapper: AnalyticsEventMapper) {
        self.eventMapper = eventMapper

        // Firebase SDK 초기화
    }

    func logEvent(_ event: AnalyticsEvent) {
        let name = eventMapper.eventName(event)
        let parameters = eventMapper.eventParameter(event)
        print("---------------Firebase--------------")
        print(name)
        print(parameters)
        print("-------------------------------------")
    }

    func setUserProperty(key: String, value: String?) {

    }

}
