import YandexMobileMetricaPush

class LateInitializer: NSObject {
    static let shared = LateInitializer()
    
    private var isDisposed = false
    private var launchOptions: [AnyHashable: Any]?
    private var deviceToken: Data?
    private var userInfo: [AnyHashable: Any]?
    
    public func setLaunchOptions(_ launchOptions: [AnyHashable: Any]) {
        self.launchOptions = launchOptions
    }
    
    public func setDeviceToken(_ deviceToken: Data) {
        if(isDisposed) {
            AppmetricaTokenSender.sendToken(deviceToken)
        } else {
            self.deviceToken = deviceToken
        }
    }
    
    public func setUserInfo(_ userInfo: [AnyHashable: Any]) {
        if(isDisposed) {
            YMPYandexMetricaPush.handleRemoteNotification(userInfo)
        } else {
            self.userInfo = userInfo
        }
    }
    
    public func initialize() {
        if isDisposed {
            return
        }
        
        isDisposed = true
        
        if let launchOptions = launchOptions {
            YMPYandexMetricaPush.handleApplicationDidFinishLaunching(options: launchOptions)
            self.launchOptions = nil
        }
        
        if let deviceToken = deviceToken {
            AppmetricaTokenSender.sendToken(deviceToken)
            self.deviceToken = nil
        }
        
        if let userInfo = userInfo {
            YMPYandexMetricaPush.handleRemoteNotification(userInfo)
            self.userInfo = nil
        }
    }
    
    public func dispose() {
        launchOptions = nil
        deviceToken = nil
        userInfo = nil
        isDisposed = false
    }
}
