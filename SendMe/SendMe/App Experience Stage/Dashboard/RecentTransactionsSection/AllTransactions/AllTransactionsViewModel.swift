import SwiftUI
import FirebaseFirestore

final class AllTransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    private let pageSize = 20
    private var lastDocument: DocumentSnapshot?
    private var hasMoreTransactions = true
    
    @MainActor
    func fetchTransactions() async {
        guard !isLoading && hasMoreTransactions else { return }
        
        isLoading = true
        error = nil
        
        do {
            var query = db.collection("transactions")
                .order(by: "date", descending: true)
                .limit(to: pageSize)
            
            if let lastDoc = lastDocument {
                query = query.start(afterDocument: lastDoc)
            }
            
            let snapshot = try await query.getDocuments()
            
            let newTransactions = snapshot.documents.compactMap { document in
                Transaction(document: document)
            }
            
            lastDocument = snapshot.documents.last
            hasMoreTransactions = !snapshot.documents.isEmpty && snapshot.documents.count == pageSize
            
            if lastDocument == nil {
                transactions = newTransactions
            } else {
                transactions.append(contentsOf: newTransactions)
            }
            
        } catch {
            self.error = error
            print("Error fetching transactions: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
} 
