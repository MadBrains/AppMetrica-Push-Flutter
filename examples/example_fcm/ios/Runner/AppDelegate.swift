import UIKit
import Flutter
import YandexMobileMetricaPush

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        YMPYandexMetricaPush.setExtensionAppGroup("group.ru.madbrains.appmetrica")
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
