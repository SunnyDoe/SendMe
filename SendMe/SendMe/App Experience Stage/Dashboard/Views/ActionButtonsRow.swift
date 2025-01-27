import SwiftUI

struct ActionButtonsRow: View {
    let addMoney: () -> Void
    let requestMoney: () -> Void
    let sendMoney: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ActionButton(title: "Add money", icon: "plus", action: addMoney)
            ActionButton(title: "Request", icon: "arrow.down", action: requestMoney)
            ActionButton(title: "Send", icon: "arrow.up", action: sendMoney)
        }
        .padding(.horizontal)
    }
} 