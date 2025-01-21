import SwiftUI

struct PaymentSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: PaymentMethodsViewModel
    @State private var selectedCard: SavedCard?
    @State private var isLoading = false
    @State private var showSuccessMessage = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Select a Payment Method")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 24)

            List(viewModel.savedCards) { card in
                Button(action: {
                    selectedCard = card
                    processPayment(for: card)
                }) {
                    HStack {
                        Text("**** \(card.lastFourDigits)")
                        Spacer()
                        if selectedCard?.id == card.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .listStyle(InsetGroupedListStyle())

            Spacer()
        }
        .overlay(
            Group {
                if isLoading {
                    ProgressView("Processing...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
        )
        .alert(isPresented: $showSuccessMessage) {
            Alert(title: Text("Success"),
                  message: Text("You have successfully upgraded!"),
                  dismissButton: .default(Text("OK")) {
                      dismiss()
                  })
        }
    }

    private func processPayment(for card: SavedCard) {
        isLoading = true
        
        // Simulate a network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            showSuccessMessage = true
        }
    }
}

#Preview {
    PaymentSelectionView(viewModel: PaymentMethodsViewModel())
}
