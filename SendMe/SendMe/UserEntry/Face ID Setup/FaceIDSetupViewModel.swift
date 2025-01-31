import Foundation
import LocalAuthentication

final class FaceIDSetupViewModel {
    private(set) var model: FaceIDSetupModel
    var onStateChanged: ((FaceIDSetupModel) -> Void)?
    var onFaceIDEnabled: (() -> Void)?
    var onProceedToPasscode: (() -> Void)?
    
    init() {
        self.model = FaceIDSetupModel()
    }
    
    func enableFaceID() {
        model.isLoading = true
        onStateChanged?(model)
        
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            model.isLoading = false
            handleBiometryError(error)
            onProceedToPasscode?()
            return
        }
        
        switch context.biometryType {
        case .faceID:
            authenticateUser(context)
        case .none:
            model.isLoading = false
            model.error = "Face ID is not set up on this device. Please set up Face ID in your device Settings."
            onStateChanged?(model)
            onProceedToPasscode?()
        default:
            model.isLoading = false
            model.error = "This device doesn't support Face ID."
            onStateChanged?(model)
            onProceedToPasscode?()
        }
    }
    
    private func handleBiometryError(_ error: NSError?) {
        let errorMessage: String
        
        if let error = error {
            switch error.code {
            case LAError.biometryNotEnrolled.rawValue:
                errorMessage = "Face ID is not set up on this device. Please set up Face ID in your device Settings."
            case LAError.biometryNotAvailable.rawValue:
                errorMessage = "Face ID is not available on this device."
            case LAError.biometryLockout.rawValue:
                errorMessage = "Face ID is locked. Please unlock it using your device passcode."
            case LAError.passcodeNotSet.rawValue:
                errorMessage = "Please set up device passcode to use Face ID."
            default:
                errorMessage = error.localizedDescription
            }
        } else {
            errorMessage = "Face ID is not available."
        }
        
        model.error = errorMessage
        onStateChanged?(model)
    }
    
    private func authenticateUser(_ context: LAContext) {
        model.isLoading = true
        onStateChanged?(model)
        
        let reason = "Enable Face ID for quick and secure access"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.model.isLoading = false
                
                if success {
                    self?.handleSuccessfulAuthentication()
                } else {
                    self?.handleAuthenticationError(error)
                }
                
                self?.onStateChanged?(self?.model ?? FaceIDSetupModel())
            }
        }
    }
    
    private func handleSuccessfulAuthentication() {
        model.isFaceIDEnabled = true
        UserDefaults.standard.set(true, forKey: "useFaceID")
        onFaceIDEnabled?()
    }
    
    private func handleAuthenticationError(_ error: Error?) {
        if let error = error as? LAError {
            switch error.code {
            case .userCancel, .userFallback:
                model.error = "Please enable Face ID to continue"
            case .biometryLockout:
                model.error = "Face ID is locked. Please unlock it using your device passcode."
            case .authenticationFailed:
                model.error = "Face ID authentication failed. Please try again."
            default:
                model.error = error.localizedDescription
                onProceedToPasscode?()
            }
        } else {
            model.error = "Failed to enable Face ID"
            onProceedToPasscode?()
        }
    }
    
    func isFaceIDAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return canEvaluate && context.biometryType == .faceID
    }
} 
