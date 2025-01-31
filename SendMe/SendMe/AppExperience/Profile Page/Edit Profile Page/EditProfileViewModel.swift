import Foundation
import UIKit
import PhotosUI
import FirebaseAuth

final class EditProfileViewModel: ObservableObject {
    @Published private(set) var state: EditProfileModel
    @Published var showingImagePicker = false
    @Published var showingActionSheet = false
    
    init() {
        let currentUser = Auth.auth().currentUser
        state = EditProfileModel(
            firstName: UserDefaults.standard.string(forKey: UserDefaults.ProfileKeys.firstName) ?? "",
            lastName: UserDefaults.standard.string(forKey: UserDefaults.ProfileKeys.lastName) ?? "",
            email: currentUser?.email ?? "",
            country: UserDefaults.standard.string(forKey: UserDefaults.ProfileKeys.country) ?? "",
            avatar: UserDefaults.standard.savedAvatar,
            isLoading: false,
            error: nil
        )
    }
    
    func updateProfile(firstName: String? = nil, lastName: String? = nil, 
                       email: String? = nil, country: String? = nil) {
        state.isLoading = true
        
        let updatedFirstName = firstName ?? state.firstName
        let updatedLastName = lastName ?? state.lastName
        let updatedEmail = email ?? state.email
        let updatedCountry = country ?? state.country
        
        state.firstName = updatedFirstName
        state.lastName = updatedLastName
        state.email = updatedEmail
        state.country = updatedCountry
        
        UserDefaults.standard.saveProfile(
            firstName: updatedFirstName,
            lastName: updatedLastName,
            email: updatedEmail,
            country: updatedCountry
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.state.isLoading = false
            
            NotificationCenter.default.post(
                name: .profileDidUpdate,
                object: nil
            )
        }
    }
    
    func updateAvatar(_ image: UIImage?) {
        state.avatar = image
        UserDefaults.standard.saveAvatar(image)
        
        NotificationCenter.default.post(
            name: .profileDidUpdate,
            object: nil
        )
    }
}

extension Notification.Name {
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
} 
