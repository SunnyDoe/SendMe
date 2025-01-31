import SwiftUI
import Charts

struct CategoryDetailView: View {
    let category: SpendingCategory
    @ObservedObject private var viewModel = AnalyticsViewModel()
    @State private var selectedTimeRange: TimeRange = .sixMonths
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back to Analytics")
                    }
                    .foregroundColor(.blue)
                }
                
                HStack {
                    Text(category.name)
                        .font(.system(size: 32, weight: .bold))
                    
                    Spacer()
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("$\(viewModel.categoryTotalSpent, specifier: "%.2f")")
                        .font(.system(size: 32, weight: .bold))
                    Text("Total spent")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            Chart {
                ForEach(viewModel.monthlyData) { data in
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value("Amount", data.amount)
                    )
                    .foregroundStyle(Color.blue.opacity(0.7))
                    .cornerRadius(8)
                }
            }
            .frame(height: 200)
            .padding(.vertical)
            .padding(.horizontal)
            .chartXAxis {
                AxisMarks(position: .bottom) {
                    AxisValueLabel()
                        .foregroundStyle(Color.gray)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisValueLabel(format: .currency(code: "USD"))
                        .foregroundStyle(Color.gray)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(TimeRange.allCases) { range in
                        Button(action: {
                            selectedTimeRange = range
                            viewModel.updateCategoryData(for: category.name, timeRange: range)
                        }) {
                            Text(range.title)
                                .font(.system(size: 15))
                                .foregroundColor(selectedTimeRange == range ? .white : .gray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedTimeRange == range ?
                                    Color.blue :
                                    Color.gray.opacity(0.1)
                                )
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            List {
                ForEach(viewModel.categoryTransactions, id: \.date) { transaction in
                    HStack {
                        Image(systemName: viewModel.mapCategoryToIcon(transaction.category))
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                            .frame(width: 32)
                        
                        Text(formatDate(transaction.date))
                            .font(.system(size: 17))
                        
                        Spacer()
                        
                        Text("$\(transaction.amount, specifier: "%.2f")")
                            .font(.system(size: 17))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(.plain)
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await viewModel.fetchAnalyticsData()
                viewModel.updateCategoryData(for: category.name, timeRange: selectedTimeRange)
            }
        }
        .onChange(of: selectedTimeRange) { newTimeRange in
            viewModel.updateCategoryData(for: category.name, timeRange: newTimeRange)
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMM yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
} 
