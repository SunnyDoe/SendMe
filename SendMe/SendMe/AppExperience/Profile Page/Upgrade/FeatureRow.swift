//
//  FeatureRow.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 21.01.25.
//

import SwiftUI

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 20))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 17))
            
            Spacer()
        }
    }
}
