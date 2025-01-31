import SwiftUI

struct PlanSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PlanType = .yearly
    @ObservedObject private var paymentMethodsViewModel = PaymentMethodsViewModel()
    @State private var showingPaymentSelection = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Choose your plan")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 24)
            
            VStack(spacing: 16) {
                PlanOptionView(
                    isSelected: selectedPlan == .yearly,
                    planType: "Yearly",
                    price: "$24.99 / year",
                    originalPrice: "$49.99",
                    details: [
                        "Start your free month today",
                        "Pay 9.90 $/month from 28 July 2023"
                    ],
                    action: { selectedPlan = .yearly }
                )
                
                PlanOptionView(
                    isSelected: selectedPlan == .monthly,
                    planType: "Monthly",
                    price: "$14.99 / month",
                    details: [
                        "Start your free month today",
                        "Pay 9.90 $/month from 28 July 2023"
                    ],
                    action: { selectedPlan = .monthly }
                )
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 8) {
                Button(action: {
                    showingPaymentSelection = true
                }) {
                    Text("Continue to checkout")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 24)
                
                Text("Plan renews automatically. Cancel anytime.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 32)
        }
        .onAppear {
            paymentMethodsViewModel.loadSavedCards()
        }
        .sheet(isPresented: $showingPaymentSelection) {
            PaymentSelectionView(viewModel: paymentMethodsViewModel)
        }
    }
}
