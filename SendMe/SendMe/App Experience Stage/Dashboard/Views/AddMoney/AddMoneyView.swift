import SwiftUI

struct AddMoneyView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddMoneyViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.bottom, 8)
            
            Text("Add money")
                .font(.system(size: 32, weight: .bold))
            
            Text("Your money is protected by the Georgian Deposit Guarantee Scheme")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 16)
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.showCurrencyAlert = true
                }) {
                    HStack {
                        Text("🇺🇸")
                        Text("USD")
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14))
                    }
                    .padding()
                    .frame(width: 130)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
                
                HStack(spacing: 0) {
                    Text("$")
                        .foregroundColor(.gray)
                        .font(.system(size: 24, weight: .medium))
                        .padding(.leading)
                    
                    TextField("0", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .medium))
                        .padding()
                }
                .frame(width: 200, height: 55)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(viewModel.validationError != nil ? Color.red : Color(.systemGray4), lineWidth: 1)
                )
                .onChange(of: viewModel.amount) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        viewModel.amount = filtered
                    }
                    if filtered.components(separatedBy: ".").count > 2 {
                        viewModel.amount = String(filtered.prefix(filtered.count - 1))
                    }
                    viewModel.validateAmount()
                }
            }
            
            if let error = viewModel.validationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            Button {
                Task {
                    await viewModel.handlePayment()
                    dismiss()
                }
            } label: {
                Text("Pay")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.isValidAmount ? Color.blue : Color.blue.opacity(0.5))
                    .cornerRadius(25)
            }
            .disabled(!viewModel.isValidAmount)
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .alert("Currency Not Available", isPresented: $viewModel.showCurrencyAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Currently, only USD is available for top-ups.")
        }
    }
}

#Preview {
    AddMoneyView()
} 
