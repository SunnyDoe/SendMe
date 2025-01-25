//
//  CardView.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 14.01.25.
//

import SwiftUI


struct CardView: View {
    let card: SavedCard
    
    var body: some View {
        HStack {
            card.brand.logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 25)
            
            VStack(alignment: .leading) {
                Text("•••• \(card.lastFourDigits)")
                    .font(.subheadline)
                Text(card.expiryDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
