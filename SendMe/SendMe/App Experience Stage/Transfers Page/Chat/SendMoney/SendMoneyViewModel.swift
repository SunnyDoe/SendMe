import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class SendMoneyViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var note: String = ""
    @Published var balance: Double = 0
    @Published var validationError: String?
    @Published var genericErrorMessage: String?
    
    private let db = Firestore.firestore()
    
    private let minSend: Double = 1.0
    private let maxSend: Double = 500.0
    
    var isValidAmount: Bool {
        guard let amount = Double(amount) else { return false }
        return amount >= minSend && amount <= maxSend && amount <= balance
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
        
        if amountValue < minSend {
            validationError = "Minimum amount is $\(minSend)"
        } else if amountValue > maxSend {
            validationError = "Maximum amount is $\(maxSend)"
        } else if amountValue > balance {
            validationError = "Insufficient balance"
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
            genericErrorMessage = "Unable to retrieve balance. Please try again later."
        }
    }
    
    func sendMoney(to userId: String) async {
        guard let amount = Double(amount) else {
            genericErrorMessage = "Please enter a valid amount to send."
            return
        }
        let messageData: [String: Any] = [
            "type": "moneySent",
            "amount": amount,
            "note": note,
            "status": "completed",
            "timestamp": Timestamp(),
            "senderId": Auth.auth().currentUser?.uid ?? "",
            "transactionId": UUID().uuidString
        ]
        
        do {
            try await db.collection("chats")
                .document(userId)
                .collection("messages")
                .addDocument(data: messageData)
            
            let recentMessage = "Sent $\(String(format: "%.2f", amount))"
            try await db.collection("users")
                .document(userId)
                .updateData([
                    "recentMessage": recentMessage,
                    "recentMessageTime": messageData["timestamp"] as Any
                ])
            
            try await db.collection("appdata")
                .document("balance")
                .updateData([
                    "amount": FieldValue.increment(-amount)
                ])
            
        } catch {
            genericErrorMessage = "Error sending money. Please try again later."
        }
    }
}
