//
//  ToastView.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 31.01.25.
//

import SwiftUI

struct InviteToastView: View {
    let message: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack {
            Spacer()
            if isVisible {
                Text(message)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(25)
                    .transition(.move(edge: .bottom))  
                    .animation(.easeInOut, value: isVisible)
            }
        }
        .padding()
    }
}

