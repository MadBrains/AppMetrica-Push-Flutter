typealias InvokerFunction = () -> Void

public class LateInvoker: NSObject {
    static let shared = LateInvoker()
    
    private var isInvoked = false
    private var functions: [InvokerFunction] = []
    
    func invoke(fn: @escaping InvokerFunction) {
        isInvoked ? fn() : functions.append(fn)
    }
    
    func invokeAll() {
        isInvoked = true
        
        functions.forEach { fn in fn() }
        functions.removeAll()
    }
    
    func dispose() {
        functions.removeAll()
        
        isInvoked = false
    }
}
