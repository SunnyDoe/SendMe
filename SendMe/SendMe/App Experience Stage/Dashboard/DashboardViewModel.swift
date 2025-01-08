import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var balance: Double = 744.50
    @Published var monthlySpending: Int = 1250
    @Published var selectedTab: Int = 0
    @Published var recentTransactions: [Transaction] = [
        Transaction(image: "julie_profile", title: "From Julie", time: "Today, 12:27 PM", amount: "+80 $"),
        Transaction(title: "Uber", time: "Today, 12:27 PM", amount: "-69.48 $"),
        Transaction(title: "Casa Ristoranti", time: "Today, 12:27 PM", amount: "-69.48 $")
    ]
    @Published var recentPayees: [Payee] = [
        Payee(image: "carlos_profile", name: "Carlos"),
        Payee(image: "tim_profile", name: "Tim"),
        Payee(image: "lidya_profile", name: "Lidya"),
        Payee(image: "erik_profile", name: "Erik"),
        Payee(image: "amelie_profile", name: "Amelie"),
        Payee(image: "lisa_profile", name: "Lisa")
    ]
    @Published var spendingData: [Double] = [20, 40, 60, 45, 85, 65, 90, 110, 85, 120]
    
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
