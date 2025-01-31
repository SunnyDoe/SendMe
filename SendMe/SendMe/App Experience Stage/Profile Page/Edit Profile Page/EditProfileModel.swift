import Foundation
import UIKit

struct EditProfileModel {
    var firstName: String
    var lastName: String
    var email: String
    var country: String
    var avatar: UIImage?
    var isLoading: Bool
    var error: String?
    
    static let initial = EditProfileModel(
        firstName: UserDefaults.standard.string(forKey: UserDefaults.ProfileKeys.firstName) ?? "",
        lastName: UserDefaults.standard.string(forKey: UserDefaults.ProfileKeys.lastName) ?? "",
        email: UserDefaults.standard.string(forKey: UserDefaults.ProfileKeys.email) ?? "",
        country: UserDefaults.standard.string(forKey: UserDefaults.ProfileKeys.country) ?? "",
        avatar: UserDefaults.standard.savedAvatar,
        isLoading: false,
        error: nil
    )
}
