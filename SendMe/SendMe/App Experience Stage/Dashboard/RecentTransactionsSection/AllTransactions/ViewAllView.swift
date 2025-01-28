//
//  ViewAllView.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 28.01.25.
//

import SwiftUI

struct HeaderWithViewAll: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Button("View all") {
                action()
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
    }
}
