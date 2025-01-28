import SwiftUI

class AddMoneyViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var selectedCurrency = "USD"
    @Published var validationError: String?
    @Published var showCurrencyAlert = false
    
    let currencies = [
        ("USD", "🇺🇸"),
        ("GEL", "🇬🇪")
    ]
    
    private let minDeposit: Double = 10.0
    private let maxDeposit: Double = 500.0
    
    var isValidAmount: Bool {
        guard let amount = Double(amount) else { return false }
        return amount >= minDeposit && amount <= maxDeposit
    }
    
    func validateAmount() {
        // First check for decimal places
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
        // Add payment processing logic here
    }
} 
