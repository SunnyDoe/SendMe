import SwiftUI

struct PaymentSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PaymentMethodsViewModel
    @State private var selectedCard: SavedCard?
    @State private var isLoading = false
    @State private var showSuccessMessage = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                .accessibilityLabel("Go back")
                
                Spacer()
                
                Text("Payment Method")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(width: 60)
            }
            .padding()
            
            VStack(spacing: 8) {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
                    .padding(.top, 8)
                
                Text("Select your card")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Choose a payment method for your subscription")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(.vertical, 24)
            
            List(viewModel.savedCards) { card in
                Button(action: { selectedCard = card }) {
                    HStack(spacing: 16) {
                        card.brand.logo
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 25)
                            .padding(8)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("•••• \(card.lastFourDigits)")
                                .font(.system(size: 17, weight: .medium))
                            Text(card.expiryDate)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if selectedCard?.id == card.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 22))
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .padding(.vertical, 4)
                )
                
            }
            .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                    Text("Payments secured by Coinbase")
                }
                .foregroundColor(.gray)
                .font(.system(size: 13))
                
                Button(action: {
                    guard let card = selectedCard else { return }
                    processPayment(for: card)
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Continue")
                                .font(.system(size: 17, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(selectedCard != nil ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .disabled(selectedCard == nil || isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            
        }
        .background(Color(.systemGroupedBackground))
        .alert(isPresented: $showSuccessMessage) {
            Alert(
                title: Text("Success"),
                message: Text("You have successfully upgraded!"),
                dismissButton: .default(Text("OK")) { dismiss() }
            )
        }
    }
    
    private func processPayment(for card: SavedCard) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            showSuccessMessage = true
        }
    }
}
