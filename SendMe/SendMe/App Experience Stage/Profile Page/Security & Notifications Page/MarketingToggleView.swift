import SwiftUI

struct MarketingToggleView: View {
    let icon: String
    let title: String
    let description: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                Spacer()
                Toggle("", isOn: $isEnabled)
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 28)
        }
    }
}
