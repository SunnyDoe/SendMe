import UIKit

struct ProfileModel {
    var username: String
    var handle: String
    var avatar: UIImage?
    var isLoading: Bool
    var error: String?
    var selectedTab: ProfileTab
    
    enum ProfileTab {
        case activity
        case replies
        case media
    }
    
    static func generateUniqueHandle() -> String {
        String(format: "%06d", Int.random(in: 100000...999999))
    }
    
    static let initial = ProfileModel(
        username: "Your Name",
        handle: UserDefaults.standard.string(forKey: "userHandle") ?? generateUniqueHandle(),
        avatar: UserDefaults.standard.savedAvatar,
        isLoading: false,
        error: nil,
        selectedTab: .activity
    )
}

extension UserDefaults {
    func saveHandle(_ handle: String) {
        set(handle, forKey: "userHandle")
    }
} 
