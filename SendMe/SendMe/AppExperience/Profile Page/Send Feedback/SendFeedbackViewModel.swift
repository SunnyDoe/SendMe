import SwiftUI

final class SendFeedbackViewModel: ObservableObject {
    @Published var feedbackText = ""
    @Published var isEditing = false
    @Published var isSending = false
    @Published var showSuccessMessage = false
    
    var remainingCharacters: Int {
        500 - feedbackText.count
    }
    
    var canSubmit: Bool {
        !feedbackText.isEmpty && !isSending
    }
    
    func validateAndUpdateText(_ newValue: String) {
        if newValue.count > 500 {
            feedbackText = String(newValue.prefix(500))
        } else {
            feedbackText = newValue
        }
    }
    
    func sendFeedback() {
        isSending = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isSending = false
            self?.showSuccessMessage = true
            self?.feedbackText = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.showSuccessMessage = false
            }
        }
    }
}
