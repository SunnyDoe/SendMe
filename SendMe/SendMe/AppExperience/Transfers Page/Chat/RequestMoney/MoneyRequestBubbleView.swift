import SwiftUI

struct MoneyRequestBubble: View {
    let amount: Double
    let note: String?
    let timestamp: Date
    let isFromCurrentUser: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text("You requested")
                .font(.system(size: 15))
                .foregroundColor(.white)
            
            Text("$\(String(format: "%.2f", amount))")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            if let note = note, !note.isEmpty {
                Text("For \(note)")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
            }
            
            Text(timestamp, style: .time)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(20)
        .padding(.horizontal)
    }
} 
