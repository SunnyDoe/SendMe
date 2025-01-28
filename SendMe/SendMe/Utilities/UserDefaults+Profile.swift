import UIKit

extension UserDefaults {
    enum ProfileKeys {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let country = "country"
        static let avatarData = "avatarData"
    }
    
    func saveProfile(firstName: String, lastName: String, email: String, country: String) {
        set(firstName, forKey: ProfileKeys.firstName)
        set(lastName, forKey: ProfileKeys.lastName)
        set(email, forKey: ProfileKeys.email)
        set(country, forKey: ProfileKeys.country)
    }
    
    func saveAvatar(_ image: UIImage?) {
        if let image = image,
           let data = image.jpegData(compressionQuality: 0.8) {
            set(data, forKey: ProfileKeys.avatarData)
        } else {
            removeObject(forKey: ProfileKeys.avatarData)
        }
    }
    
    var savedAvatar: UIImage? {
        if let data = data(forKey: ProfileKeys.avatarData) {
            return UIImage(data: data)
        }
        return nil
    }
} 