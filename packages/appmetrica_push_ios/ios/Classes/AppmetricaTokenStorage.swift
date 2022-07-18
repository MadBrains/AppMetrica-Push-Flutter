import Foundation

enum AppmetricaTokenStorage {
    static func saveToken(_ token: Data?) {
        UserDefaults.standard.set(token, forKey: Constants.userDefaultsTokenKey)
    }

    static func getToken() -> Data? {
        return UserDefaults.standard.data(forKey: Constants.userDefaultsTokenKey)
    }
}
