import SwiftUI
import FirebaseFirestore

@MainActor
class AddMoneyViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var selectedCurrency = "USD"
    @Published var validationError: String?
    @Published var showCurrencyAlert = false
    @Published var showNoCardAlert = false
    @Published var showPaymentSuccessToast = false
    @Published var lastChargedCard: SavedCard?
    
    private let db = Firestore.firestore()
    private let paymentMethodsViewModel = PaymentMethodsViewModel()
    
    let currencies = [
        ("USD", "🇺🇸")
    ]
    
    private let minDeposit: Double = 10.0
    private let maxDeposit: Double = 500.0
    
    var isValidAmount: Bool {
        guard let amount = Double(amount) else { return false }
        return amount >= minDeposit && amount <= maxDeposit
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
        
        if amountValue < minDeposit {
            validationError = "Minimum deposit amount is $\(minDeposit)"
        } else if amountValue > maxDeposit {
            validationError = "Maximum deposit amount is $\(maxDeposit)"
        } else {
            validationError = nil
        }
    }
    
    func handlePayment() async {
        if paymentMethodsViewModel.savedCards.isEmpty {
            showNoCardAlert = true
            return
        }
        
        guard let amountValue = Double(amount),
              let firstCard = paymentMethodsViewModel.savedCards.first else {
            return
        }
        
        do {
            lastChargedCard = firstCard
            
            let currentBalance = try await fetchCurrentBalance()
            let newBalance = currentBalance + amountValue
            
            try await db.collection("appdata").document("balance").setData([
                "amount": newBalance
            ])
            
            await MainActor.run {
                showPaymentSuccessToast = true
            }
        } catch {
            print("Error updating balance: \(error.localizedDescription)")
        }
    }
    
    private func fetchCurrentBalance() async throws -> Double {
        let document = try await db.collection("appdata").document("balance").getDocument()
        return document.data()?["amount"] as? Double ?? 0
    }
} 
