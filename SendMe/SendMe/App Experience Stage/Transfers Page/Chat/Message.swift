import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Message: Identifiable {
    let id: String
    let text: String
    let timestamp: Date
    let isFromCurrentUser: Bool
    let type: String
    let amount: Double?
    let note: String?
    let status: String?
    
    init?(id: String, data: [String: Any]) {
        guard let timestamp = data["timestamp"] as? Timestamp,
              let senderId = data["senderId"] as? String else {
            return nil
        }
        
        self.id = id
        self.timestamp = timestamp.dateValue()
        self.isFromCurrentUser = senderId == Auth.auth().currentUser?.uid
        self.type = data["type"] as? String ?? "text"
        
        if self.type == "moneyRequest" {
            self.amount = data["amount"] as? Double
            self.note = data["note"] as? String
            self.status = data["status"] as? String
            self.text = "Money Request: $\(data["amount"] as? Double ?? 0)"
        } else {
            self.text = data["text"] as? String ?? ""
            self.amount = nil
            self.note = nil
            self.status = nil
        }
    }
} 
