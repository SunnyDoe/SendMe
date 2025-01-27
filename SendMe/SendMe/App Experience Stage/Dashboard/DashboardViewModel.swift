import SwiftUI
import FirebaseFirestore

class DashboardViewModel: ObservableObject {
    @Published var balance: Double = 0
    @Published var monthlySpending: Int = 1250
    @Published var selectedTab: Int = 0
    @Published var isLoading = false
    @Published var error: Error?
    @Published var recentTransactions: [Transaction] = []
    @Published var recentPayees: [Payee] = []
    @Published var spendingData: [Double] = [20, 40, 60, 45, 85, 65, 90, 110, 85, 120]
    @Published var showAllTransactions = false
    
    private let db = Firestore.firestore()
    
    init() {
        Task {
            await fetchBalance()
            await fetchRecentTransactions()
        }
    }
    
    @MainActor
    func fetchBalance() async {
        isLoading = true
        error = nil
        
        do {
            let document = try await db.collection("appdata").document("balance").getDocument()
            
            if document.exists {
                if let balance = document.data()?["amount"] as? Double {
                    self.balance = balance
                } else {
                    print("Error: 'amount' field not found or invalid type")
                }
            } else {
                print("Error: Document does not exist")
            }
        } catch {
            self.error = error
            print("Error fetching balance: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func fetchRecentTransactions() async {
        do {
            let snapshot = try await db.collection("transactions")
                .order(by: "date", descending: true)
                .limit(to: 3)
                .getDocuments()
            
            let transactions = snapshot.documents.compactMap { document in
                Transaction(document: document)
            }
            
            print("Fetched transactions count: \(transactions.count)")
            self.recentTransactions = transactions
            
        } catch {
            self.error = error
            print("Error fetching transactions: \(error.localizedDescription)")
        }
    }
    
    func addMoney() {
        // Implementation coming soon
    }
    
    func requestMoney() {
        // Implementation coming soon
    }
    
    func sendMoney() {
        // Implementation coming soon
    }
    
    func search() {
        // Implementation coming soon
    }
    
    func showNotifications() {
        // Implementation coming soon
    }
} 
