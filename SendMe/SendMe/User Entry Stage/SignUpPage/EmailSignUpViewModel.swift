import Foundation

class EmailSignUpViewModel {
    struct ViewState {
        var isEmailValid: Bool = false
        var errorMessage: String?
        var isButtonEnabled: Bool = false
    }
    
    private(set) var state: ViewState = ViewState() {
        didSet {
            onStateChanged?(state)
        }
    }
    
    var onStateChanged: ((ViewState) -> Void)?
    
    func validateEmail(_ email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValid = emailPred.evaluate(with: email)
        
        state = ViewState(
            isEmailValid: isValid,
            errorMessage: isValid ? nil : "Please enter a valid email address",
            isButtonEnabled: isValid
        )
    }
    
    func handleContinue(withEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if state.isEmailValid {
            completion(.success(()))
        } else {
            completion(.failure(ValidationError.invalidEmail))
        }
    }
}

enum ValidationError: LocalizedError {
    case invalidEmail
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        }
    }
} 

