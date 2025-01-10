import Foundation
import FirebaseAuth

final class PasswordViewModel {
    struct ViewState {
        var passwordCriteria: [PasswordCriteria: Bool]
        var isButtonEnabled: Bool
        
        init(passwordCriteria: [PasswordCriteria: Bool], isButtonEnabled: Bool) {
            self.passwordCriteria = passwordCriteria
            self.isButtonEnabled = isButtonEnabled
        }
        
        init() {
            self.passwordCriteria = [
                .minCharacters: false,
                .noNameOrEmail: false,
                .symbolOrNumber: false,
                .noSpaces: false
            ]
            self.isButtonEnabled = false
        }
    }
    
    enum PasswordCriteria: String, CaseIterable {
        case minCharacters = "Must be at least 8 characters"
        case noNameOrEmail = "Can't include your name or email address"
        case symbolOrNumber = "Must have at least one symbol or number"
        case noSpaces = "Can't contain spaces"
    }
    
    private(set) var state: ViewState = ViewState() {
        didSet {
            onStateChanged?(state)
        }
    }
    
    var onStateChanged: ((ViewState) -> Void)?
    private var userEmail: String
    private var auth: Auth
    
    init(userEmail: String) {
        self.userEmail = userEmail
        self.auth = Auth.auth()
    }
    
    func validatePassword(_ password: String) {
        var criteria = state.passwordCriteria
        
        criteria[.minCharacters] = password.count >= 8
        
        criteria[.noSpaces] = !password.contains(" ")
        
        let symbolNumberRegex = ".*[^A-Za-z].*"
        criteria[.symbolOrNumber] = password.range(of: symbolNumberRegex, options: .regularExpression) != nil
        
        criteria[.noNameOrEmail] = !password.lowercased().contains(userEmail.lowercased())
        
        let isValid = criteria.values.allSatisfy { $0 }
        state = ViewState(passwordCriteria: criteria, isButtonEnabled: isValid)
    }
    
    func handleContinue(withPassword password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if state.isButtonEnabled {
            auth.createUser(withEmail: userEmail, password: password) { [weak self] authResult, error in
                if let error = error {
                    completion(.failure(self?.mapFirebaseError(error) ?? error))
                    return
                }
                
                completion(.success(()))
            }
        } else {
            completion(.failure(PasswordValidationError.invalidPassword))
        }
    }
    
    private func mapFirebaseError(_ error: Error) -> Error {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return SignUpError.emailAlreadyInUse
        case AuthErrorCode.weakPassword.rawValue:
            return SignUpError.weakPassword
        default:
            return error
        }
    }
}

enum PasswordValidationError: LocalizedError {
    case invalidPassword
    
    var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return "Please ensure your password meets all requirements"
        }
    }
}

enum SignUpError: LocalizedError {
    case emailAlreadyInUse
    case weakPassword
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse:
            return "This email is already registered. Please try signing in instead."
        case .weakPassword:
            return "The password is too weak. Please make it stronger."
        }
    }
} 
