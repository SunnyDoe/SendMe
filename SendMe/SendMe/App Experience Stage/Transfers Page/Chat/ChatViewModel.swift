import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    @Published var isLoading = false
    @Published var error: Error?
    
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
            self.error = error
            print("Error fetching messages: \(error.localizedDescription)")
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
            print("Error adding initial message: \(error.localizedDescription)")
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
                    "recentMessageTime": messageData["timestamp"]
                ])
            
        } catch {
            self.error = error
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}
