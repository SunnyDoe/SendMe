import Foundation
import Combine

final class PrivacySettingsViewModel: ObservableObject {
    @Published private(set) var state: PrivacySettingsModel = .initial
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadPrivacySettings()
    }
    
    private func loadPrivacySettings() {
        state = PrivacySettingsModel(
            selectedPrivacyLevel: UserDefaults.standard.privacyLevel,
            isLoading: false,
            error: nil
        )
    }
    
    func updatePrivacyLevel(_ level: PrivacySettingsModel.PrivacyLevel) {
        state.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            UserDefaults.standard.privacyLevel = level
            
            self?.state.selectedPrivacyLevel = level
            self?.state.isLoading = false
            
            NotificationCenter.default.post(
                name: .privacyLevelDidChange,
                object: nil,
                userInfo: ["level": level]
            )
        }
    }
}

extension Notification.Name {
    static let privacyLevelDidChange = Notification.Name("privacyLevelDidChange")
} 
