import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

enum Preferences {
    @UserDefault(key: "autoHideEnabled", defaultValue: false)
    static var autoHideEnabled: Bool

    @UserDefault(key: "autoHideDelay", defaultValue: 10.0)
    static var autoHideDelay: Double

    @UserDefault(key: "launchAtLogin", defaultValue: false)
    static var launchAtLogin: Bool

    @UserDefault(key: "showSeparator", defaultValue: true)
    static var showSeparator: Bool
}
