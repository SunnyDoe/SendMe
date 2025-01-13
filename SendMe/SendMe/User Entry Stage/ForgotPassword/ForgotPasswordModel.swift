import Foundation

struct ForgotPasswordModel {
    var isLoading: Bool
    var error: String?
    var isSuccess: Bool
    
    static let initial = ForgotPasswordModel(isLoading: false, error: nil, isSuccess: false)
} 