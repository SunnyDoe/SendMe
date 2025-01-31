import Foundation
import FirebaseAuth

class LoginViewModel {
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    private let keychain = KeychainManager.shared

    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    self.onLoginError?("Incorrect email or password")
                case AuthErrorCode.invalidEmail.rawValue:
                    self.onLoginError?("Invalid email format")
                case AuthErrorCode.userNotFound.rawValue:
                    self.onLoginError?("Incorrect email or password")
                case AuthErrorCode.userDisabled.rawValue:
                    self.onLoginError?("This account has been disabled")
                case AuthErrorCode.invalidCredential.rawValue:
                    self.onLoginError?("Incorrect email or password")
                case AuthErrorCode.networkError.rawValue:
                    self.onLoginError?("Network error. Please check your connection")
                case AuthErrorCode.tooManyRequests.rawValue:
                    self.onLoginError?("Too many attempts. Please try again later")
                default:
                    print("Firebase error: \(error.localizedDescription)")
                    self.onLoginError?("Unable to sign in. Please try again")
                }
                return
            }
            
            if authResult?.user != nil {
                self.keychain.save(email, forKey: "userEmail")
                self.keychain.save(password, forKey: "userPassword")
                self.onLoginSuccess?()
            } else {
                self.onLoginError?("Authentication failed. Please try again")
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
