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
                            addMoney: viewModel.addMoney,
                            requestMoney: viewModel.requestMoney,
                            sendMoney: viewModel.sendMoney
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

struct PayeeView: View {
    let payee: Payee
    
    var body: some View {
        VStack {
            Image(payee.image ?? "person.crop.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            Text(payee.name)
                .font(.caption)
        }
    }
}

struct HeaderWithViewAll: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Button("View all") {
                action()
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            ForEach(0..<4) { index in
                Spacer()
                TabBarItem(
                    icon: tabBarItems[index].icon,
                    title: tabBarItems[index].title,
                    isSelected: selectedTab == index
                ) {
                    selectedTab = index
                }
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .top)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
    }
}

#Preview {
    DashboardView()
}
