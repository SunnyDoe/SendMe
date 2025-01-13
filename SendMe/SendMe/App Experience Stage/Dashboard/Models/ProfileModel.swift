import UIKit

struct ProfileModel {
    var username: String
    var handle: String
    var avatar: UIImage?
    var friendCount: Int
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
        username: "",
        handle: UserDefaults.standard.string(forKey: "userHandle") ?? generateUniqueHandle(),
        avatar: nil,
        friendCount: 0,
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
