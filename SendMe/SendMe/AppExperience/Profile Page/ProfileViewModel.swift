import Foundation
import UIKit
import Combine
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    @Published private(set) var state: ProfileModel = .initial
    @Published var showingPrivacySettings = false
    @Published var showingEditProfile = false
    private var cancellables = Set<AnyCancellable>()
    private let keychain = KeychainManager.shared
    
    init() {
        loadUserProfile()
        setupNotificationObservers()
        
        
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.publisher(for: .profileDidUpdate)
            .sink { [weak self] _ in
                self?.loadUserProfile()
            }
            .store(in: &cancellables)
    }
    
    func loadUserProfile() {
        let firstName = UserDefaults.standard.string(forKey: UserDefaults.ProfileKeys.firstName) ?? "Your Name"
        
        state = ProfileModel(
            username: firstName,
            avatar: UserDefaults.standard.savedAvatar,
            isLoading: false,
            error: nil
        )
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            keychain.delete(forKey: "userEmail")
            keychain.delete(forKey: "userPassword")
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let signInView = SignInView()
                let navigationController = UINavigationController(rootViewController: signInView)
                navigationController.modalPresentationStyle = .fullScreen
                
                window.rootViewController = navigationController
                
                UIView.transition(with: window,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    
    func showPrivacySettings() {
        showingPrivacySettings = true
    }
    
    func showEditProfile() {
        showingEditProfile = true
    }
}
