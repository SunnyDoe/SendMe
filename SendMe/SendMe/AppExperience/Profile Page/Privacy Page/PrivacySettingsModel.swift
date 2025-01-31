import Foundation

struct PrivacySettingsModel {
    enum PrivacyLevel: String, CaseIterable, Codable {
        case `public` = "Public"
        case friends = "Friends"
        case `private` = "Private"
        
        var description: String {
            switch self {
            case .public:
                return "Visible to everyone on the Internet"
            case .friends:
                return "Visible to sender, recipient, and their friends"
            case .private:
                return "Visible to sender and recipient only"
            }
        }
    }
    
    var selectedPrivacyLevel: PrivacyLevel
    var isLoading: Bool
    var error: String?
    
    static let initial = PrivacySettingsModel(
        selectedPrivacyLevel: UserDefaults.standard.privacyLevel,
        isLoading: false,
        error: nil
    )
}

extension UserDefaults {
    private enum Keys {
        static let privacyLevel = "privacyLevel"
    }
    
    var privacyLevel: PrivacySettingsModel.PrivacyLevel {
        get {
            if let savedValue = string(forKey: Keys.privacyLevel),
               let level = PrivacySettingsModel.PrivacyLevel(rawValue: savedValue) {
                return level
            }
            return .public
        }
        set {
            set(newValue.rawValue, forKey: Keys.privacyLevel)
        }
    }
}
