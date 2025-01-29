import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class RequestMoneyViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var note: String = ""
    @Published var balance: Double = 0
    @Published var validationError: String?
    
    private let db = Firestore.firestore()
    
    private let minRequest: Double = 1.0
    private let maxRequest: Double = 500.0
    
    var isValidAmount: Bool {
        guard let amount = Double(amount) else { return false }
        return amount >= minRequest && amount <= maxRequest
    }
    
    func validateAmount() {
        if amount.contains(".") {
            let parts = amount.split(separator: ".")
            if parts.count == 2 && parts[1].count > 2 {
                amount = String(format: "%.2f", Double(amount) ?? 0)
            }
        }
        
        guard let amountValue = Double(amount) else {
            validationError = "Please enter a valid amount"
            return
        }
        
        if amountValue < minRequest {
            validationError = "Minimum amount is $\(minRequest)"
        } else if amountValue > maxRequest {
            validationError = "Maximum amount is $\(maxRequest)"
        } else {
            validationError = nil
        }
    }
    
    func fetchBalance() async {
        do {
            let document = try await db.collection("appdata")
                .document("balance")
                .getDocument()
            
            if let data = document.data(),
               let amount = data["amount"] as? Double {
                self.balance = amount
            }
        } catch {
            print("Error fetching balance: \(error.localizedDescription)")
        }
    }
    
    func sendMoneyRequest(to userId: String) async {
        guard let amount = Double(amount) else { return }
        
        let messageData: [String: Any] = [
            "type": "moneyRequest",
            "amount": amount,
            "note": note,
            "status": "pending",
            "timestamp": Timestamp(),
            "senderId": Auth.auth().currentUser?.uid ?? "",
            "requestId": UUID().uuidString
        ]
        
        do {
            try await db.collection("chats")
                .document(userId)
                .collection("messages")
                .addDocument(data: messageData)
            
            let recentMessage = "Requested $\(String(format: "%.2f", amount))"
            try await db.collection("users")
                .document(userId)
                .updateData([
                    "recentMessage": recentMessage,
                    "recentMessageTime": messageData["timestamp"]
                ])
            
        } catch {
            print("Error sending money request: \(error.localizedDescription)")
        }
    }
} 
