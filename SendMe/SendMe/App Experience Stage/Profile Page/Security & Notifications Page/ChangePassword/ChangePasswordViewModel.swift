import Foundation
import FirebaseAuth
import Combine

final class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var passwordCriteria: [PasswordCriteria: Bool] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    enum PasswordCriteria: String {
        case minCharacters = "Must be at least 8 characters"
        case noNameOrEmail = "Can't include your name or email address"
        case symbolOrNumber = "Must have at least one symbol or number"
        case noSpaces = "Can't contain spaces"
        case notSameAsOld = "New password must be different from current password"
        case passwordsMatch = "Passwords must match"
    }
    
    var isFormValid: Bool {
        !currentPassword.isEmpty &&
        !newPassword.isEmpty &&
        !confirmPassword.isEmpty &&
        passwordCriteria.allSatisfy { $0.value } &&
        newPassword == confirmPassword
    }
    
    init() {
        setupPasswordValidation()
        initializeCriteria()
    }
    
    private func initializeCriteria() {
        passwordCriteria = [
            .minCharacters: false,
            .noNameOrEmail: false,
            .symbolOrNumber: false,
            .noSpaces: false,
            .notSameAsOld: false,
            .passwordsMatch: false
        ]
    }
    
    private func setupPasswordValidation() {
        Publishers.CombineLatest3($currentPassword, $newPassword, $confirmPassword)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] currentPwd, newPwd, confirmPwd in
                self?.validatePassword(current: currentPwd, new: newPwd, confirm: confirmPwd)
            }
            .store(in: &cancellables)
    }
    
    private func validatePassword(current: String, new: String, confirm: String) {
        passwordCriteria[.minCharacters] = new.count >= 8
        passwordCriteria[.noSpaces] = !new.contains(" ")
        passwordCriteria[.symbolOrNumber] = new.range(of: "[^a-zA-Z]", options: .regularExpression) != nil
        passwordCriteria[.notSameAsOld] = !new.isEmpty && new != current
        passwordCriteria[.passwordsMatch] = !confirm.isEmpty && new == confirm
        
        passwordCriteria[.noNameOrEmail] = true
    }
    
    func changePassword() {
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not found. Please sign in again."
            isLoading = false
            return
        }
        
        let credential = EmailAuthProvider.credential(
            withEmail: user.email ?? "",
            password: currentPassword
        )
        
        user.reauthenticate(with: credential) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
                return
            }
            
            user.updatePassword(to: self?.newPassword ?? "") { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    } else {
                        NotificationCenter.default.post(name: .passwordChanged, object: nil)
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let passwordChanged = Notification.Name("passwordChanged")
}
