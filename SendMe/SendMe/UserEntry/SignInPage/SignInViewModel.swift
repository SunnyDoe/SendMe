import Foundation

final class SignInViewModel {
    enum NavigationAction {
        case emailSignUp
        case appleSignIn
        case existingUserSignIn
    }
    
    var onNavigationRequested: ((NavigationAction) -> Void)?
    
    func navigateToEmailSignUp() {
        onNavigationRequested?(.emailSignUp)
    }
    
    func handleAppleSignIn() {
        onNavigationRequested?(.appleSignIn)
    }
    
    func handleExistingUserSignIn() {
        onNavigationRequested?(.existingUserSignIn)
    }
} 
