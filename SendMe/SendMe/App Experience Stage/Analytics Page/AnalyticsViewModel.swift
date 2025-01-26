import Foundation
import SwiftUI


class AnalyticsViewModel: ObservableObject {
    @Published var totalSpent: Double = 0
    @Published var monthlyData: [MonthlySpending] = []
    @Published var categories: [SpendingCategory] = []
    @Published var isLoading = false
    @Published var error: Error?
    private var analyticsData: AnalyticsResponse?
    private var currentTimeRange: TimeRange = .overall
    
    private var cachedData: [TimeRange: [MonthlySpending]] = [:]
    
    init() {
        Task {
            await fetchAnalyticsData()
        }
    }
    
    @MainActor
    func fetchAnalyticsData() async {
        isLoading = true
        cachedData.removeAll()
        guard let url = URL(string: "https://my.api.mockaroo.com/users.json?key=217e9ec0") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            let response = try decoder.decode(AnalyticsResponse.self, from: data)
            self.analyticsData = response
            
            self.totalSpent = response.totalSpent["overall"] ?? 0
            updateMonthlyData(from: response.spendingDetails, for: currentTimeRange)
            updateCategories(for: currentTimeRange)
            
        } catch {
            print("Error fetching analytics data: \(error)")
            self.error = error
        }
        isLoading = false
    }
    
    func updateTotalSpent(for timeRange: TimeRange) {
        guard timeRange != currentTimeRange else { return }
        
        currentTimeRange = timeRange
        guard let data = analyticsData else { return }
        
        self.totalSpent = data.totalSpent[timeRange.rawValue] ?? 0
        
        updateCategories(for: timeRange)
        
        if let details = analyticsData?.spendingDetails {
            updateMonthlyData(from: details, for: timeRange)
        }
    }

    
    private func updateCategories(for timeRange: TimeRange) {
        guard let response = analyticsData else { return }
        
        let categorySpending = response.categorySpent[timeRange.rawValue] ?? [:]
        let transactionCounts = response.transactionsCount[timeRange.rawValue] ?? [:]
        
        self.categories = categorySpending.map { category in
            SpendingCategory(
                id: UUID(),
                name: category.key.replacingOccurrences(of: "_", with: " ").capitalized,
                icon: mapCategoryToIcon(category.key),
                amount: category.value,
                transactionCount: transactionCounts[category.key] ?? 0
            )
        }.sorted { $0.amount > $1.amount } 
    }

    
    private func updateMonthlyData(from details: [SpendingDetail], for timeRange: TimeRange) {
        if let cachedMonthlyData = cachedData[timeRange] {
            self.monthlyData = cachedMonthlyData
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        let dateLimit: Date
        switch timeRange {
        case .week:
            dateLimit = calendar.date(byAdding: .day, value: -7, to: currentDate)!
            dateFormatter.dateFormat = "d MMM"
        case .month:
            dateLimit = calendar.date(byAdding: .month, value: -1, to: currentDate)!
            dateFormatter.dateFormat = "d MMM"
        case .threeMonths:
            dateLimit = calendar.date(byAdding: .month, value: -3, to: currentDate)!
            dateFormatter.dateFormat = "MMM"
        case .sixMonths:
            dateLimit = calendar.date(byAdding: .month, value: -6, to: currentDate)!
            dateFormatter.dateFormat = "MMM"
        case .year:
            dateLimit = calendar.date(byAdding: .year, value: -1, to: currentDate)!
            dateFormatter.dateFormat = "MMM"
        case .overall:
            dateLimit = calendar.date(from: DateComponents(year: 2017))!
            dateFormatter.dateFormat = "yyyy"
        }
        
        let filteredDetails = details.filter { detail in
            guard let date = dateFormatter.date(from: detail.date) else { return false }
            return date >= dateLimit && date <= currentDate
        }
        
        var dailyTotals: [String: Double] = [:]
        var dates: [String: Date] = [:]
        
        var date = dateLimit
        let baseAmount = 1000.0
        let trendMultiplier: Double
        
        switch timeRange {
        case .week, .month, .year:
            trendMultiplier = 0.9
        case .threeMonths, .sixMonths:
            trendMultiplier = 1.1
        case .overall:
            trendMultiplier = 1.15
        }
        
        while date <= currentDate {
            let dateKey = dateFormatter.string(from: date)
            let progress = Double(calendar.dateComponents([.day], from: dateLimit, to: date).day ?? 0) /
                          Double(calendar.dateComponents([.day], from: dateLimit, to: currentDate).day ?? 1)
            
            let trendFactor = pow(trendMultiplier, progress)
            dailyTotals[dateKey] = baseAmount * trendFactor
            dates[dateKey] = date
            
            if timeRange == .week {
                date = calendar.date(byAdding: .day, value: 1, to: date)!
            } else if timeRange == .overall {
                date = calendar.date(byAdding: .year, value: 1, to: date)!
            } else {
                date = calendar.date(byAdding: .month, value: 1, to: date)!
            }
        }
        
        for detail in filteredDetails {
            if let date = dateFormatter.date(from: detail.date) {
                let dateKey = dateFormatter.string(from: date)
                dailyTotals[dateKey] = detail.amount
                dates[dateKey] = date
            }
        }
        
        let generatedData = dailyTotals.map { dateStr, amount in
            MonthlySpending(
                id: UUID(),
                month: dateStr,
                amount: amount,
                date: dates[dateStr] ?? Date.distantPast
            )
        }.sorted { $0.date < $1.date }
        
        cachedData[timeRange] = generatedData
        self.monthlyData = generatedData
    }
    
    private func mapCategoryToIcon(_ category: String) -> String {
        switch category.lowercased() {
        case "bills": return "house.fill"
        case "eating_out": return "fork.knife"
        case "groceries": return "cart.fill"
        case "entertainment": return "tv.fill"
        case "transport": return "car.fill"
        default: return "creditcard.fill"
        }
    }
    
    func getTrend(for month: String) -> TrendIndicator? {
        guard let currentIndex = monthlyData.firstIndex(where: { $0.month == month }),
              currentIndex > 0 else { return nil }
        
        let currentAmount = monthlyData[currentIndex].amount
        let previousAmount = monthlyData[currentIndex - 1].amount
        
        let difference = currentAmount - previousAmount
        let percentageChange = (difference / previousAmount) * 100
        
        if abs(percentageChange) > 10 {
            return difference > 0 ? TrendIndicator.increase : TrendIndicator.decrease
        }
        return nil
    }
}
