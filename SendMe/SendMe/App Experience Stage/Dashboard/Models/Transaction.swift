import Foundation
import FirebaseFirestore

struct Transaction: Identifiable {
    let id: String
    let name: String
    let date: Date
    let amount: Double
    let imageURL: String?
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
    var formattedAmount: String {
        return amount >= 0 ? "+$\(String(format: "%.2f", abs(amount)))" : "-$\(String(format: "%.2f", abs(amount)))"
    }
    
    init(id: String, name: String, date: Date, amount: Double, imageURL: String? = nil) {
        self.id = id
        self.name = name
        self.date = date
        self.amount = amount
        self.imageURL = imageURL
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String,
              let timestamp = data["date"] as? Timestamp,
              let amount = data["amount"] as? Double else {
            return nil
        }
        
        self.id = document.documentID
        self.name = name
        self.date = timestamp.dateValue()
        self.amount = amount
        self.imageURL = data["imageURL"] as? String
    }
} 
