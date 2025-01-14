import SwiftUI

class SendFeedbackViewModel: ObservableObject {
    @Published var feedbackText = ""
    @Published var isEditing = false
    
    var remainingCharacters: Int {
        500 - feedbackText.count
    }
    
    var canSubmit: Bool {
        !feedbackText.isEmpty
    }
    
    func validateAndUpdateText(_ newValue: String) {
        if newValue.count > 500 {
            feedbackText = String(newValue.prefix(500))
        } else {
            feedbackText = newValue
        }
    }
} 