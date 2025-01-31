//
//  PlanOption.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 21.01.25.
//

import SwiftUI

struct PlanOptionView: View {
    let isSelected: Bool
    let planType: String
    let price: String
    var originalPrice: String? = nil
    let details: [String]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(planType)
                            .font(.system(size: 17))
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(price)
                                .font(.system(size: 17, weight: .semibold))
                            
                            if let originalPrice = originalPrice {
                                Text(originalPrice)
                                    .strikethrough()
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 2)
                        .background(Circle().fill(isSelected ? Color.blue : Color.clear))
                        .frame(width: 24, height: 24)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(details, id: \.self) { detail in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                            Text(detail)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
