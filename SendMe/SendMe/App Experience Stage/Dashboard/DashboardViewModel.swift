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
    @Published var monthlyExpense: MonthlyExpense?
    
    private let db = Firestore.firestore()
    
    init() {
        Task {
            await fetchBalance()
            await fetchRecentTransactions()
            await fetchMonthlyExpense()
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
                .limit(to: 4)
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
    
    @MainActor
    func fetchMonthlyExpense() async {
        do {
            let document = try await db.collection("monthlyexpense")
                .document("total")
                .getDocument()
            
            if let data = document.data() {
                self.monthlyExpense = MonthlyExpense(data: data)
            }
        } catch {
            self.error = error
            print("Error fetching monthly expense: \(error.localizedDescription)")
        }
    }
    
    func addMoney() {
    }
    
    func requestMoney() {
    }
    
    func sendMoney() {
    }
    
    func search() {
    }
    
    func showNotifications() {
    }
} 
