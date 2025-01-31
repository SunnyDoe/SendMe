import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var userId: String = ""
    
    func fetchMessages(for userId: String) async {
        self.userId = userId
        isLoading = true
        
        do {
            let snapshot = try await db.collection("chats")
                .document(userId)
                .collection("messages")
                .order(by: "timestamp", descending: false)
                .getDocuments()
            
            self.messages = snapshot.documents.compactMap { document in
                Message(id: document.documentID, data: document.data())
            }
            
            if messages.isEmpty {
                await addInitialMessage(for: userId)
            }
        } catch {
            self.errorMessage = "Failed to load messages. Please try again later."
        }
        
        isLoading = false
    }
    
    private func addInitialMessage(for userId: String) async {
        do {
            let userDoc = try await db.collection("users")
                .document(userId)
                .getDocument()
            
            if let userData = userDoc.data(),
               let recentMessage = userData["recentMessage"] as? String,
               let timestamp = userData["recentMessageTime"] as? Timestamp {
                
                let messageData: [String: Any] = [
                    "text": recentMessage,
                    "timestamp": timestamp,
                    "senderId": userId
                ]
                
                try await db.collection("chats")
                    .document(userId)
                    .collection("messages")
                    .addDocument(data: messageData)
                
                await fetchMessages(for: userId)
            }
        } catch {
            self.errorMessage = "Failed to load initial message. Please try again later."
        }
    }
    
    func sendMessage() async {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let text = messageText
        messageText = ""
        
        let messageData: [String: Any] = [
            "text": text,
            "timestamp": Timestamp(),
            "senderId": Auth.auth().currentUser?.uid ?? ""
        ]
        
        do {
            let docRef = try await db.collection("chats")
                .document(userId)
                .collection("messages")
                .addDocument(data: messageData)
            
            let newMessage = Message(id: docRef.documentID, data: messageData)
            if let message = newMessage {
                messages.append(message)
            }
            
            try await db.collection("users")
                .document(userId)
                .updateData([
                    "recentMessage": text,
                    "recentMessageTime": messageData["timestamp"] as Any
                ])
            self.errorMessage = nil
            
        } catch {
            self.errorMessage = "Failed to send message. Please try again later."
        }
    }
}
