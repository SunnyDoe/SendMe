//
//  CategoryRow.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 25.01.25.
//

import SwiftUI


struct CategoryRow: View {
    let category: SpendingCategory
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 32, height: 32)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.system(size: 17, weight: .medium))
                Text("\(category.transactionCount) transactions")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("-$\(category.amount, specifier: "%.2f")")
                .font(.system(size: 17, weight: .semibold))
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }
}
