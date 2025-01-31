import Foundation
import FirebaseAuth

final class PasswordViewModel {
    private let userEmail: String
    var onStateChanged: ((PasswordModel) -> Void)?
    
    private var state: PasswordModel = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    init(userEmail: String) {
        self.userEmail = userEmail
    }
    
    func validatePassword(_ password: String) {
        var criteria = state.passwordCriteria
        
        criteria[.minCharacters] = password.count >= 8
        
        criteria[.noSpaces] = !password.contains(" ")
        
        let symbolNumberRegex = ".*[^A-Za-z].*"
        criteria[.symbolOrNumber] = password.range(of: symbolNumberRegex, options: .regularExpression) != nil
        
        criteria[.noNameOrEmail] = !password.lowercased().contains(userEmail.lowercased())
        
        let isButtonEnabled = criteria.values.allSatisfy { $0 }
        state = PasswordModel(passwordCriteria: criteria, isButtonEnabled: isButtonEnabled)
    }
    
    func handleContinue(withPassword password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: userEmail, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
} 
