import Foundation

enum Utils {
    static func string(tokenData deviceToken: Data?) -> String? {
        guard let deviceToken = deviceToken, !deviceToken.isEmpty else {
            return nil
        }
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        return token
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
}
