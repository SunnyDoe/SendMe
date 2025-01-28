import SwiftUI

struct RecentTransactionsSection: View {
    let transactions: [Transaction]
    let onViewAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HeaderWithViewAll(title: "Recent transactions", action: onViewAll)
            
            LazyVStack(spacing: 8) {
                ForEach(transactions) { transaction in
                    TransactionRow(transaction: transaction)
                    
                    if transaction.id != transactions.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
    }
} 