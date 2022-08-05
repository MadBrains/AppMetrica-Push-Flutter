import Flutter
import UIKit
import UserNotifications // iOS 10
import YandexMobileMetrica
import YandexMobileMetricaPush

public class SwiftAppmetricaPushIosPlugin: NSObject, FlutterPlugin {
    private static var methodChannel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        methodChannel = FlutterMethodChannel(name: Constants.methodChannel,
                                             binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: Constants.eventChannel,
                                               binaryMessenger: registrar.messenger())
        
        guard let methodChannel = methodChannel else {
            return
        }
        
        
        let eventHandler = AppmetricaPushEventHandler.shared
        let methodHandler = AppmetricaPushMethodHandler(channel: methodChannel,
                                                        eventHandler: eventHandler)
        
        registrar.addMethodCallDelegate(methodHandler, channel: methodChannel)
        registrar.addApplicationDelegate(methodHandler)
        
        eventChannel.setStreamHandler(eventHandler)
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        AppmetricaPushEventHandler.shared.dispose()
        LateInvoker.shared.dispose()
        LateInitializer.shared.dispose()
    }
    
    
    
    //MARK: - Application delegate
    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        if #available(iOS 10.0, *) {
            let delegate = YMPYandexMetricaPush.userNotificationCenterDelegate()
            delegate.nextDelegate = self
            UNUserNotificationCenter.current().delegate = delegate
        }
        
        LateInitializer.shared.setLaunchOptions(launchOptions)
        registerForPushNotificationsWithApplication(application)
        
        if let userInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            handlePushNotification(userInfo: userInfo, pushType: PushType.normal)
        }
        
        return true
    }
    
    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        LateInitializer.shared.setDeviceToken(deviceToken)
        AppmetricaTokenStorage.saveToken(deviceToken)
        
        let strToken = Utils.string(tokenData: deviceToken)
        let tokens = strToken == nil ? [:] : ["apns": strToken]
        print(tokens)
        
        AppmetricaPushEventHandler.shared.add(tokens: tokens)
    }
    
    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error))")
    }
    
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        handlePushNotification(userInfo: userInfo, pushType: PushType.silent)
        completionHandler(.newData)
        // TODO: sure if true?
        return true
    }
    
    private func registerForPushNotificationsWithApplication(_ application: UIApplication) {
        guard #available(iOS 8.0, *) else {
            // iOS 7.0 and below
            application.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
            return
        }
        
        if #available(iOS 10.0, *) {
            // iOS 10.0 and above
            let center = UNUserNotificationCenter.current()
            let category = UNNotificationCategory(identifier: "Custom category",
                                                  actions: [],
                                                  intentIdentifiers: [],
                                                  options:UNNotificationCategoryOptions.customDismissAction)
            center.setNotificationCategories(Set([category]))
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                //TODO: Enable or disable features based on authorization.
            }
        } else {
            // iOS 8 and iOS 9
            let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    //MARK: - Notification delegate
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        handlePushNotification(userInfo: userInfo, pushType: PushType.normal)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        handlePushNotification(userInfo: userInfo, pushType: PushType.normal)
        
        completionHandler()
    }
    
    //MARK: - Common
    private func handlePushNotification(userInfo: [AnyHashable: Any],
                                        pushType: PushType) {
        LateInitializer.shared.setUserInfo(userInfo)
        
        if YMPYandexMetricaPush.isNotificationRelated(toSDK: userInfo),
           let userData = YMPYandexMetricaPush.userData(forNotification: userInfo) {
            print("User Data: %@", userData.description)
            
            switch (pushType) {
            case .normal:
                LateInvoker.shared.invoke {
                    SwiftAppmetricaPushIosPlugin.methodChannel?
                        .invokeMethod(Constants.onMessageOpenedApp, arguments: userData)
                }
            case .silent:
                LateInvoker.shared.invoke {
                    SwiftAppmetricaPushIosPlugin.methodChannel?
                        .invokeMethod(Constants.onMessage, arguments: userData)
                }
            }
        } else {
            print("Push is not related to AppMetrica")
        }
    }
}
