import Foundation
import FirebaseAuth

class LoginViewModel {
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    private let keychain = KeychainManager.shared

    
    func login(email: String, password: String) {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    self?.onLoginError?(error.localizedDescription)
                    return
                }
                
                if authResult?.user != nil {
                    self?.keychain.save(email, forKey: "userEmail")
                    self?.keychain.save(password, forKey: "userPassword")

                    self?.onLoginSuccess?()
                } else {
                    self?.onLoginError?("Authentication failed. Please try again.")
                }
            }
        }

        func getStoredCredentials() -> (email: String, password: String)? {
            if let email = keychain.get(forKey: "userEmail"),
               let password = keychain.get(forKey: "userPassword") {
                return (email, password)
            }
            return nil
        }
    }
