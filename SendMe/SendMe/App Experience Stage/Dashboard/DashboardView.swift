import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text("$\(viewModel.balance, specifier: "%.2f")")
                                .font(.system(size: 40, weight: .bold))
                            Text("Total balance")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)
                        
                        HStack(spacing: 16) {
                            ActionButton(title: "Add money", icon: "plus", action: viewModel.addMoney)
                            ActionButton(title: "Request money", icon: "arrow.down", action: viewModel.requestMoney)
                            ActionButton(title: "Send", icon: "arrow.up", action: viewModel.sendMoney)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HeaderWithViewAll(title: "Recent transactions")
                            
                            ForEach(viewModel.recentTransactions) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("$\(viewModel.monthlySpending)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Spent this month")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            SpendingChart(data: viewModel.spendingData)
                                .frame(height: 100)
                        }
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HeaderWithViewAll(title: "Recent payees")
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(viewModel.recentPayees) { payee in
                                        PayeeView(payee: payee)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CountryButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 16) {
                            Button(action: viewModel.search) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.primary)
                            }
                            Button(action: viewModel.showNotifications) {
                                Image(systemName: "bell")
                                    .foregroundColor(.primary)
                            }
                        }
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
            Image(payee.image)
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
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Button("View all") {
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
    }
}

struct CountryButton: View {
    var body: some View {
        Button(action: {}) {
            Image("us_flag") 
                .resizable()
                .frame(width: 30, height: 20)
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
