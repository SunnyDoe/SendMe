import Foundation
import FirebaseAuth

class LoginViewModel {
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.onLoginError?(error.localizedDescription)
                return
            }
            
            if authResult?.user != nil {
                self?.onLoginSuccess?()
            } else {
                self?.onLoginError?("Authentication failed. Please try again.")
            }
        }
    }
} 
