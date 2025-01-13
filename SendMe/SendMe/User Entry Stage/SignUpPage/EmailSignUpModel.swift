import Foundation

struct EmailSignUpModel {
    var isLoading: Bool
    var error: String?
    var isEmailValid: Bool
    var canProceed: Bool
    
    static let initial = EmailSignUpModel(
        isLoading: false,
        error: nil,
        isEmailValid: false,
        canProceed: false
    )
} 