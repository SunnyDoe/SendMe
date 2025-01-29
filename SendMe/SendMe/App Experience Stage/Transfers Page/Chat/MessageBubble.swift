import SwiftUI

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
            }
            
            if message.type == "moneyRequest" {
                MoneyRequestBubble(
                    amount: message.amount ?? 0,
                    note: message.note,
                    timestamp: message.timestamp,
                    isFromCurrentUser: message.isFromCurrentUser
                )
            } else {
                Text(message.text)
                    .padding(12)
                    .background(message.isFromCurrentUser ? Color.blue : Color(.systemGray6))
                    .foregroundColor(message.isFromCurrentUser ? .white : .primary)
                    .cornerRadius(20)
            }
            
            if !message.isFromCurrentUser {
                Spacer()
            }
        }
    }
} 