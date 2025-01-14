//
//  SettingsRow.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 14.01.25.
//

import SwiftUI

struct SettingsRow: View {
    let icon: String
    let title: String
    var iconColor: Color = .blue
    var textColor: Color = .primary
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            Text(title)
                .foregroundColor(textColor)
            
            Spacer()
            
          
            }
        .padding(.vertical, 4)
        }
    }
