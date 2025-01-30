import SwiftUI

struct SendMoneyView: View {
    let user: User
    let onCompletion: () -> Void
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SendMoneyViewModel()
    
    private let currencies = [("USD", "🇺🇸")]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("Send Money")
                        .font(.system(size: 17, weight: .semibold))
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                
                ScrollView {
                    VStack(spacing: 24) {
                        Color.clear.frame(height: 20)
                        
                        HStack {
                            Text(user.fullName)
                                .font(.system(size: 24, weight: .semibold))
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: user.profilePic)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .empty, .failure:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                @unknown default:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            Menu {
                                ForEach(currencies, id: \.0) { currency, flag in
                                    Button(action: {}) {
                                        Label("\(flag) \(currency)", systemImage: "")
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("🇺🇸 USD")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(width: 150)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                            }
                            
                            HStack {
                                Text("$")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 24, weight: .medium))
                                
                                TextField("0", text: $viewModel.amount)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 24, weight: .medium))
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .frame(width: 150)
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
                        .padding(.horizontal)
                        
                        if let error = viewModel.validationError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        HStack {
                            Text("Balance: $\(String(format: "%.2f", viewModel.balance))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("No fees")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        TextField("Add note", text: $viewModel.note)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .padding(.horizontal)
                    }
                }
                
                Button(action: {
                    Task {
                        await viewModel.sendMoney(to: user.id)
                        onCompletion()
                        dismiss()
                    }
                }) {
                    Text("Send")
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
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchBalance()
        }
    }
} 
