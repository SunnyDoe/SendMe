import SwiftUI
import FirebaseFirestore

struct AllTransactionsView: View {
    @StateObject private var viewModel = AllTransactionsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.transactions) { transaction in
                        TransactionRow(transaction: transaction)
                        
                        if transaction.id != viewModel.transactions.last?.id {
                            Divider()
                        }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
            .refreshable {
                await viewModel.fetchTransactions()
            }
        }
        .task {
            await viewModel.fetchTransactions()
        }
    }
}
