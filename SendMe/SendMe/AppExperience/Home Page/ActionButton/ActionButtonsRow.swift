import SwiftUI

struct ActionButtonsRow: View {
    let addMoney: () -> Void
    
    
    var body: some View {
        HStack() {
            ActionButton(title: "Add money", icon: "plus", action: addMoney)
        }
        .padding(.horizontal)
        .frame(width: 120)
    }
}
