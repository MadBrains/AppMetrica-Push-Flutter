import YandexMobileMetrica
import YandexMobileMetricaPush

public class AppmetricaPushEventHandler: NSObject, FlutterStreamHandler {
    static let shared = AppmetricaPushEventHandler()
    
    private var eventSink: FlutterEventSink?
    
    public func onListen(withArguments arguments: Any?,
                         eventSink event: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = event
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        dispose()
        return nil
    }
    
    public func add(tokens: Dictionary<String, String?>) {
        if let sink = eventSink {
            sink(tokens)
        }
    }
    
    public func dispose() {
        eventSink = nil
    }
}
