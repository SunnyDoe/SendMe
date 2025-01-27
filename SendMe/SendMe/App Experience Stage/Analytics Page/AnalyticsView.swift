import SwiftUI
import Charts


struct AnalyticsView: View {
    @ObservedObject private var viewModel = AnalyticsViewModel()
    @State private var selectedTimeRange: TimeRange = .overall
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(TimeRange.allCases) { range in
                                Button(action: {
                                    selectedTimeRange = range
                                    viewModel.updateTotalSpent(for: range)
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("$\(viewModel.totalSpent, specifier: "%.2f")")
                            .font(.system(size: 32, weight: .bold))
                        Text("Total spent")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Chart {
                            ForEach(viewModel.monthlyData) { data in
                                LineMark(
                                    x: .value("Month", data.month),
                                    y: .value("Amount", data.amount)
                                )
                                .interpolationMethod(.monotone)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .blue.opacity(0.7)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                
                                AreaMark(
                                    x: .value("Month", data.month),
                                    y: .value("Amount", data.amount)
                                )
                                .interpolationMethod(.monotone)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.green.opacity(0.2),
                                            Color.green.opacity(0.05)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                
                                PointMark(
                                    x: .value("Month", data.month),
                                    y: .value("Amount", data.amount)
                                )
                                .foregroundStyle(Color.blue)
                                .symbolSize(30)
                                
                                if let trend = viewModel.getTrend(for: data.month) {
                                    PointMark(
                                        x: .value("Month", data.month),
                                        y: .value("Amount", data.amount)
                                    )
                                    .foregroundStyle(trend.color)
                                    .symbolSize(40)
                                    .annotation(position: .top) {
                                        Image(systemName: trend.icon)
                                            .foregroundStyle(trend.color)
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
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
                        .chartYScale(domain: .automatic(includesZero: true))
                        .padding(.vertical)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("By category")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        ForEach(viewModel.categories) { category in
                            NavigationLink(destination: CategoryDetailView(category: category)) {
                                CategoryRow(category: category)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Analytics")
            .refreshable {
                await viewModel.fetchAnalyticsData()
            }
        }
    }
}


#Preview {
    AnalyticsView()
}
