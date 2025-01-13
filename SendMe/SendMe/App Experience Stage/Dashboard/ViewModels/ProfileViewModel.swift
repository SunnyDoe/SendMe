import Foundation
import UIKit
import Combine
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    @Published private(set) var state: ProfileModel = .initial
    @Published var showingPrivacySettings = false
    @Published var showingEditProfile = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUserProfile()
        setupNotificationObservers()
        
        if UserDefaults.standard.string(forKey: "userHandle") == nil {
            let handle = ProfileModel.generateUniqueHandle()
            UserDefaults.standard.saveHandle(handle)
        }
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
        let handle = UserDefaults.standard.string(forKey: "userHandle") ?? ProfileModel.generateUniqueHandle()
        
        state = ProfileModel(
            username: firstName,
            handle: handle,
            avatar: UserDefaults.standard.savedAvatar,
            friendCount: state.friendCount,
            isLoading: false,
            error: nil,
            selectedTab: state.selectedTab
        )
    }
    
    func selectTab(_ tab: ProfileModel.ProfileTab) {
        state.selectedTab = tab
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            state.error = error.localizedDescription
        }
    }
    
    func showPrivacySettings() {
        showingPrivacySettings = true
    }
    
    func showEditProfile() {
        showingEditProfile = true
    }
} 
