import UIKit

struct ProfileModel {
    var username: String
    var avatar: UIImage?
    var isLoading: Bool
    var error: String?
    
    static let initial = ProfileModel(
        username: "Your Name",
        avatar: UserDefaults.standard.savedAvatar,
        isLoading: false,
        error: nil
    )
}

