//
//  Models.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 25.01.25.
//

import SwiftUI

enum TimeRange: String, CaseIterable, Identifiable {
    case week = "1_week"
    case month = "1_month"
    case threeMonths = "3_months"
    case sixMonths = "6_months"
    case year = "1_year"
    case overall = "overall"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .week: return "1W"
        case .month: return "1M"
        case .threeMonths: return "3M"
        case .sixMonths: return "6M"
        case .year: return "1Y"
        case .overall: return "All"
        }
    }
}

struct MonthlySpending: Identifiable {
    let id: UUID
    let month: String
    let amount: Double
    let date: Date
}

struct SpendingCategory: Identifiable {
    let id: UUID
    let name: String
    let icon: String
    let amount: Double
    let transactionCount: Int
}

struct SpendingDetail: Codable {
    let amount: Double
    let category: String
    let date: String
}

struct AnalyticsResponse: Codable {
    let totalSpent: [String: Double]
    let categorySpent: [String: Double]
    let spendingDetails: [SpendingDetail]
    
    enum CodingKeys: String, CodingKey {
        case totalSpent = "total_spent"
        case categorySpent = "category_spent"
        case spendingDetails = "spending_details"
    }
}

struct TrendIndicator {
    let icon: String
    let color: Color
    
    static let increase = TrendIndicator(icon: "arrow.up.circle.fill", color: .red)
    static let decrease = TrendIndicator(icon: "arrow.down.circle.fill", color: .green)
    static let stable = TrendIndicator(icon: "circle.fill", color: .yellow)
}

