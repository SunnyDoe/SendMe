import Foundation

struct MonthlyExpense {
    let total: Double
    let categories: [ExpenseCategory]
    
    struct ExpenseCategory: Identifiable {
        let id = UUID()
        let name: String
        let amount: Double
        let total: Double
        
        var percentage: Double {
            amount / total * 100
        }
    }
    
    init?(data: [String: Any]) {
        guard let total = data["amount"] as? Double else { return nil }
        self.total = total
        
        let categoryFields = ["bills", "eating_out", "health", "entertainment", "uncategorized"]
        var categories: [ExpenseCategory] = []
        
        for field in categoryFields {
            if let amount = data[field] as? Double {
                categories.append(ExpenseCategory(
                    name: field.replacingOccurrences(of: "_", with: " ").capitalized,
                    amount: amount,
                    total: total
                ))
            }
        }
        
        self.categories = categories
    }
} 