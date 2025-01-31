import Foundation

struct PasswordModel {
    var passwordCriteria: [PasswordCriteria: Bool]
    var isButtonEnabled: Bool
    
    enum PasswordCriteria: String, CaseIterable {
        case minCharacters = "Must be at least 8 characters"
        case noNameOrEmail = "Can't include your name or email address"
        case symbolOrNumber = "Must have at least one symbol or number"
        case noSpaces = "Can't contain spaces"
    }
    
    static let initial = PasswordModel(
        passwordCriteria: [
            .minCharacters: false,
            .noNameOrEmail: false,
            .symbolOrNumber: false,
            .noSpaces: false
        ],
        isButtonEnabled: false
    )
} 