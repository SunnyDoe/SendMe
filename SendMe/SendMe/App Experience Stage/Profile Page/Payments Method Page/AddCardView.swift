import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddCardViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Link your card")
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Name on the card", text: $viewModel.cardName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: .gray.opacity(0.1), radius: 1)
                        )
                        .textContentType(.name)
                        .onChange(of: viewModel.cardName) { _ in
                            viewModel.validateForm()
                        }
                    
                    if let error = viewModel.cardNameError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        TextField("Card number", text: $viewModel.cardNumber)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.numberPad)
                            .textContentType(.creditCardNumber)
                            .onChange(of: viewModel.cardNumber) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count <= 16 {
                                    viewModel.formatCardNumber(newValue)
                                    viewModel.validateForm()
                                }
                            }
                        
                        viewModel.cardBrand.logo
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 25)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: .gray.opacity(0.1), radius: 1)
                    )
                    
                    if let error = viewModel.cardNumberError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading)
                    }
                }
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("MM/YY", text: $viewModel.expiryDate)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .gray.opacity(0.1), radius: 1)
                            )
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.expiryDate) { newValue in
                                viewModel.formatExpiryDate(newValue)
                                viewModel.validateForm()
                            }
                        
                        if let error = viewModel.expiryDateError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        SecureField("CVC", text: $viewModel.cvc)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .gray.opacity(0.1), radius: 1)
                            )
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.cvc) { _ in
                                viewModel.validateForm()
                            }
                        
                        if let error = viewModel.cvcError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading)
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("By adding a new card, you agree to the ")
                    .foregroundColor(.gray) +
                Text("credit & debit card terms")
                    .foregroundColor(.blue)
                
                Button(action: {
                    Task {
                        await viewModel.addCard()
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text("Add card")
                        }
                    }
                    .font(.headline)
                    .foregroundColor(viewModel.isFormValid ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.isFormValid ? Color.blue : Color(.systemGray5))
                    .cornerRadius(25)
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)
                
                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    Text("Processed by ")
                        .foregroundColor(.gray) +
                    Text("Coinbase")
                        .foregroundColor(.blue)
                }
                .font(.footnote)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
} 
