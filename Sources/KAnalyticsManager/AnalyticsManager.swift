import Foundation

/*
재사용성, 확장성 고려
테스터블한 코드 작성
의존성주입 방식

 ### Usage

 ```
 let finalLog = AnalyticsManager(providers: [
     FirebaseProvider(eventMapper: FirebaseMapper()),
     AppsFlyerProvider(eventMapper: AppsFlyerEventMapper())
 ])

 finalLog.log(DemoLoginEvent.login(success: true, type: "kakao"))
 ```

 ### Reference Links

 1. https://medium.com/macoclock/abstraction-analytics-layer-for-swift-39636ede5e67
 2. https://www.swiftbysundell.com/articles/building-an-enum-based-analytics-system-in-swift/
 3. https://medium.com/swift-programming/a-modular-analytics-layer-in-swift-564a95039596
 4. https://medium.com/smart-cloud/analytics-and-tracking-best-practices-in-ios-apps-dedb8f328e97
 5. https://medium.com/@MdNiks/building-scalable-and-flexible-analytics-architecture-for-ios-using-dependency-injection-7795ed79b322
 6. https://medium.com/stackademic/mastering-firebase-analytics-and-a-b-testing-in-ios-a-real-world-guide-bb497caa1a95
 7. https://noob-programmer.medium.com/crafting-an-efficient-analytics-framework-part-1-7d0c2907bfb1

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
