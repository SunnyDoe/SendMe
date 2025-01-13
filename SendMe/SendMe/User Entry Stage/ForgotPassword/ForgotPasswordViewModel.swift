import Foundation
import FirebaseAuth

final class ForgotPasswordViewModel {
    var onStateChanged: ((ForgotPasswordModel) -> Void)?
    private var state: ForgotPasswordModel = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    func resetPassword(email: String) {
        state = ForgotPasswordModel(isLoading: true, error: nil, isSuccess: false)
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.state = ForgotPasswordModel(isLoading: false, error: error.localizedDescription, isSuccess: false)
            } else {
                self?.state = ForgotPasswordModel(isLoading: false, error: nil, isSuccess: true)
            }
        }
    }
} 