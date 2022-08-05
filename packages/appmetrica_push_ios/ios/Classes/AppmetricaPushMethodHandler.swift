import Flutter
import UIKit
import YandexMobileMetrica
import YandexMobileMetricaPush

public class AppmetricaPushMethodHandler: SwiftAppmetricaPushIosPlugin {
    private var channel: FlutterMethodChannel
    private var eventHandler: AppmetricaPushEventHandler
    
    init(channel: FlutterMethodChannel, eventHandler: AppmetricaPushEventHandler) {
        self.channel = channel
        self.eventHandler = eventHandler
        super.init()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments: String? = call.arguments as? String
        
        switch CallMethods(rawValue: call.method) {
        case .activate:
            activate(result: result, arguments: arguments)
        case .getTokens:
            getTokens(result: result)
        case .requestPermission:
            requestPermission(result: result, arguments: arguments)
        case .none:
            result(nil)
        }
    }
    
    private func activate(result: @escaping FlutterResult, arguments: String?) {
        LateInitializer.shared.initialize()
        
        let metricaPlugin = YMMYandexMetrica.getPluginExtension()
        metricaPlugin.handlePluginInitFinished()
        result(nil)
        
        LateInvoker.shared.invokeAll()
    }
    
    private func getTokens(result: @escaping FlutterResult) {
        if let token = Utils.string(tokenData: AppmetricaTokenStorage.getToken()) {
            result(["apns": token])
        } else {
            result(nil)
        }
    }
    
    private func requestPermission(result: @escaping FlutterResult, arguments: String?) {
        guard let arguments = arguments,
              let args = Utils.convertToDictionary(text: arguments) else {
            result(nil)
            return
        }
        
        var options: UNAuthorizationOptions = []
        
        if let alert = args["alert"] as? Bool, alert {
            options.insert(.alert)
        }
        
        if let badge = args["badge"] as? Bool, badge {
            options.insert(.badge)
        }
        
        if let sound = args["sound"] as? Bool, sound {
            options.insert(.sound)
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (didAllow, error) in
            // TODO: handle error
            result(didAllow)
        }
    }
}

