import Foundation
import FirebaseAuth

class LoginViewModel {
    private(set) var model: LoginModel
    var onStateChanged: ((LoginModel) -> Void)?
    var onLoginSuccess: (() -> Void)?
    
    init() {
        self.model = LoginModel()
    }
    
    func login(email: String, password: String) {
        model.isLoading = true
        onStateChanged?(model)
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            model.isLoading = false
            model.error = "Please fill in all fields"
            onStateChanged?(model)
            return
        }
        
        Auth.auth().signIn(withEmail: trimmedEmail, password: trimmedPassword) { [weak self] result, error in
            self?.model.isLoading = false
            
            if let error = error {
                let errorCode = AuthErrorCode(_bridgedNSError: error as NSError)
                switch errorCode?.code {
                case .wrongPassword:
                    self?.model.error = "Incorrect password. Please try again."
                case .invalidEmail:
                    self?.model.error = "Invalid email format."
                case .userNotFound:
                    self?.model.error = "No account found with this email."
                case .userDisabled:
                    self?.model.error = "This account has been disabled."
                case .tooManyRequests:
                    self?.model.error = "Too many attempts. Please try again later."
                default:
                    self?.model.error = "Login failed. Please try again."
                }
            } else {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self?.onLoginSuccess?()
            }
            
            self?.onStateChanged?(self?.model ?? LoginModel())
        }
    }
} 
