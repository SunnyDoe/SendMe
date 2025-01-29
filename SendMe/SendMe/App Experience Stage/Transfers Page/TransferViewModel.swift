import SwiftUI
import FirebaseFirestore

@MainActor
class TransferViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchText = ""
    
    private let db = Firestore.firestore()
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        }
        return users.filter { user in
            user.fullName.lowercased().contains(searchText.lowercased())
        }
    }
    
    func fetchUsers() async {
        isLoading = true
        error = nil
        
        do {
            let snapshot = try await db.collection("users")
                .getDocuments()
            
            self.users = snapshot.documents.compactMap { document in
                User(id: document.documentID, data: document.data())
            }
            
        } catch {
            self.error = error
            print("Error fetching users: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
