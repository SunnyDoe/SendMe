import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 10) {
                        BalanceSection(
                            balance: viewModel.balance,
                            monthlySpending: viewModel.monthlySpending
                        )
                        
                        ActionButtonsRow(
                            addMoney: viewModel.addMoney
                        )
                        
                        if !viewModel.recentTransactions.isEmpty {
                            RecentTransactionsSection(
                                transactions: viewModel.recentTransactions,
                                onViewAll: { viewModel.showAllTransactions = true }
                                
                            )
                            .sheet(isPresented: $viewModel.showAllTransactions) {
                                AllTransactionsView()
                            }
                            
                            if let monthlyExpense = viewModel.monthlyExpense {
                                MonthlyExpenseSection(monthlyExpense: monthlyExpense)
                                    .padding(.horizontal)
                            }
                            if !viewModel.recentTransactions.isEmpty {
                                RecentPayeesSection(transactions: viewModel.recentTransactions)
                                    .padding(.horizontal)
                                    .sheet(isPresented: $viewModel.showAddMoney) {
                                        AddMoneyView()
                                    }
                            }
                        }
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .refreshable {
                    Task {
                        await viewModel.fetchBalance()
                        await viewModel.fetchRecentTransactions()
                    }
                }
            }
            .tag(0)
            
            NavigationView {
                TransferView()
                    .navigationTitle("Transfer")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tag(1)
            
            NavigationView {
                AnalyticsView()
                    .navigationTitle("Analytics")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tag(2)
            
            NavigationView {
                ProfileView()
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tag(3)
        }
        .overlay(
            CustomTabBar(selectedTab: $viewModel.selectedTab)
                .background(Color(.systemBackground))
            , alignment: .bottom
        )
    }
}


#Preview {
    DashboardView()
}
