import Foundation

final class SecurityNotificationsViewModel: ObservableObject {
    private enum UserDefaultsKeys {
        static let isPushEnabled = "isPushEnabled"
        static let isTextEnabled = "isTextEnabled"
        static let isEmailEnabled = "isEmailEnabled"
        static let isFaceIDEnabled = "isFaceIDEnabled"
    }
    
    @Published var isFaceIDEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isFaceIDEnabled, forKey: UserDefaultsKeys.isFaceIDEnabled)
        }
    }
    
    @Published var isPushEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isPushEnabled, forKey: UserDefaultsKeys.isPushEnabled)
        }
    }
    
    @Published var isTextEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isTextEnabled, forKey: UserDefaultsKeys.isTextEnabled)
        }
    }
    
    @Published var isEmailEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEmailEnabled, forKey: UserDefaultsKeys.isEmailEnabled)
        }
    }
    
    @Published var showFaceIDAlert = false
    
    let pushDescription = "I'm happy to receive push notifications about our products, services and offers that may interest me"
    let textDescription = "I'm happy to receive text messages about our products, services and offers that may interest me"
    let emailDescription = "I'm happy to receive emails about our products, services and offers that may interest me"
    
    init() {
        self.isFaceIDEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFaceIDEnabled)
        self.isPushEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isPushEnabled)
        self.isTextEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isTextEnabled)
        self.isEmailEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isEmailEnabled)
    }
    
    func toggleFaceID() {
        showFaceIDAlert = true
    }
    
}
