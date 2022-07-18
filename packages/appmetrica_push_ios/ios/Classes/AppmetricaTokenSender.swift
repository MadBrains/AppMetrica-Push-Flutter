import Foundation
import YandexMobileMetricaPush

class AppmetricaTokenSender: NSObject {
    public class func sendToken(_ deviceToken: Data?) {
#if DEBUG
        let pushEnvironment = YMPYandexMetricaPushEnvironment.development
#else
        let pushEnvironment = YMPYandexMetricaPushEnvironment.production
#endif
        // Method YMMYandexMetrica.activate should be called before using this method
        YMPYandexMetricaPush.setDeviceTokenFrom(deviceToken, pushEnvironment: pushEnvironment)
    }
}
