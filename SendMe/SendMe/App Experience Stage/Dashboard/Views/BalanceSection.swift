import SwiftUI

struct BalanceSection: View {
    let balance: Double
    let monthlySpending: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Balance")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("$\(String(format: "%.2f", balance))")
                .font(.system(size: 34, weight: .bold))
            
        }
        .padding(.top)
    }
} 
