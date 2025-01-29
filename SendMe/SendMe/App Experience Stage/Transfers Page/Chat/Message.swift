import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Message: Identifiable {
    let id: String
    let text: String
    let timestamp: Date
    let isFromCurrentUser: Bool
    
    init?(id: String, data: [String: Any]) {
        guard let text = data["text"] as? String,
              let timestamp = data["timestamp"] as? Timestamp,
              let senderId = data["senderId"] as? String else {
            return nil
        }
        
        self.id = id
        self.text = text
        self.timestamp = timestamp.dateValue()
        self.isFromCurrentUser = senderId == Auth.auth().currentUser?.uid
    }
} 
