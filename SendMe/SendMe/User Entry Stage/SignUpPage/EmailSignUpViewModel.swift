import Foundation
import FirebaseAuth

final class EmailSignUpViewModel {
    var onStateChanged: ((EmailSignUpModel) -> Void)?
    
    private var state: EmailSignUpModel = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    private var currentEmail: String = ""
    
    func validateEmail(_ email: String) {
        currentEmail = email
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
        
        if !isEmailValid {
            state = EmailSignUpModel(
                isLoading: false,
                error: "Please enter a valid email address",
                isEmailValid: false,
                canProceed: false
            )
        } else {
            state = EmailSignUpModel(
                isLoading: false,
                error: nil,
                isEmailValid: true,
                canProceed: true
            )
        }
    }
    
    func checkEmailAvailability(_ email: String) {
        currentEmail = email
        state = EmailSignUpModel(
            isLoading: true,
            error: nil,
            isEmailValid: state.isEmailValid,
            canProceed: false
        )
        
        Auth.auth().fetchSignInMethods(forEmail: email) { [weak self] methods, error in
            if let error = error {
                self?.state = EmailSignUpModel(
                    isLoading: false,
                    error: error.localizedDescription,
                    isEmailValid: true,
                    canProceed: false
                )
            } else if let methods = methods, !methods.isEmpty {
                self?.state = EmailSignUpModel(
                    isLoading: false,
                    error: "Email already in use",
                    isEmailValid: true,
                    canProceed: false
                )
            } else {
                self?.state = EmailSignUpModel(
                    isLoading: false,
                    error: nil,
                    isEmailValid: true,
                    canProceed: true
                )
            }
        }
    }
} 

