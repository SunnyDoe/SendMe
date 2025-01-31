import SwiftUI
import Charts

struct MonthlyExpenseSection: View {
    let monthlyExpense: MonthlyExpense
    
    private let colors: [Color] = [.blue, .green, .orange, .purple, .red]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("This Month's Expenses")
                    .font(.headline)
                
                Text("$\(monthlyExpense.total, specifier: "%.2f")")
                    .font(.system(size: 28, weight: .bold))
            }
            
            Chart(monthlyExpense.categories) { category in
                SectorMark(
                    angle: .value("Amount", category.amount),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .foregroundStyle(colors[monthlyExpense.categories.firstIndex(where: { $0.id == category.id })! % colors.count])
            }
            .frame(height: 200)
            .padding(.vertical)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                ForEach(Array(monthlyExpense.categories.enumerated()), id: \.element.id) { index, category in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(colors[index % colors.count])
                            .frame(width: 12, height: 12)
                        
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.subheadline)
                            Text("\(Int(category.percentage))% ($\(category.amount, specifier: "%.2f"))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
