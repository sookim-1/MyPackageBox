import Foundation

/*
재사용성, 확장성 고려
테스터블한 코드 작성
의존성주입 방식

 Usage :

 ```
 let finalLog = AnalyticsManager(providers: [
     FirebaseProvider(eventMapper: FirebaseMapper()),
     AppsFlyerProvider(eventMapper: AppsFlyerEventMapper())
 ])

 finalLog.log(DemoLoginEvent.login(success: true, type: "kakao"))
 ```

 */

/// AnalyticsManager :  provider 관리 중앙 집중 관리 용도 객체
final class AnalyticsManager {

    private let providers: [AnalyticsProvider]

    init(providers: [AnalyticsProvider]) {
        self.providers = providers
    }

    func log(_ event: AnalyticsEvent) {
        print("--- Logging Event: \(event.name) ---")

        providers
            .filter { event.targetServices.contains($0.serviceType) }
            .forEach { provider in
                provider.logEvent(event)

                if (event.userProperties != nil) {
                    if let mappedUserProperties = provider.eventMapper.userProperties(event, serviceType: provider.serviceType) {
                         mappedUserProperties.forEach { key, value in
                             provider.setUserProperty(key: key, value: value)
                         }
                    }
                }
            }

        print("--- Event Logging Complete ---")
    }

    func initializeAnalyticsServices() {
        print("Initializing analytics services...")

        // 해당 함수에서 각 Provider 별 SDK 초기화
    }

}
