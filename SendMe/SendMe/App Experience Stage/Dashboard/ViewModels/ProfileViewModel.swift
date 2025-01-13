import Foundation
import FirebaseAuth
import Combine

final class ProfileViewModel: ObservableObject {
    @Published private(set) var state: ProfileModel = .initial
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUserProfile()
    }
    
    func loadUserProfile() {
        state = ProfileModel(
            username: "Your Name",
            handle: "@yourhandle",
            friendCount: 4,
            isLoading: false,
            error: nil,
            selectedTab: .activity
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
} 
