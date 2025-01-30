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
        self.id = id
        self.isFromCurrentUser = data["senderId"] as? String == Auth.auth().currentUser?.uid
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
        self.type = data["type"] as? String ?? "text"
        
        if self.type == "moneyRequest" || self.type == "moneySent" {
            self.amount = data["amount"] as? Double
            self.note = data["note"] as? String
            self.status = data["status"] as? String
            self.text = ""
        } else {
            self.text = data["text"] as? String ?? ""
            self.amount = nil
            self.note = nil
            self.status = nil
        }
    }
} 
