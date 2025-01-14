import SwiftUI

struct SendFeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SendFeedbackViewModel()
    
    var body: some View {
        ZStack {
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
                    
                    Text("Send feedback")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                        .frame(width: 60)
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.feedbackText)
                            .frame(height: 150)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.isEditing ? Color.black : Color.gray, lineWidth: 1)
                            )
                            .onTapGesture {
                                viewModel.isEditing = true
                            }
                            .onChange(of: viewModel.feedbackText) { newValue in
                                viewModel.validateAndUpdateText(newValue)
                            }
                        
                        if viewModel.feedbackText.isEmpty {
                            Text("How can we improve experience for you?")
                                .font(.system(size: 17))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .allowsHitTesting(false)
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("\(viewModel.remainingCharacters) characters remain")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                Spacer()
                
                Button(action: {
                    viewModel.sendFeedback()
                }) {
                    HStack {
                        if viewModel.isSending {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.trailing, 8)
                        }
                        
                        Text(viewModel.isSending ? "Sending..." : "Send feedback")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.canSubmit ? Color.blue : Color.gray)
                    .cornerRadius(25)
                }
                .disabled(!viewModel.canSubmit)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            
            if viewModel.showSuccessMessage {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Thank you for your feedback! Your input helps us improve and make the app better for everyone")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.easeInOut, value: viewModel.showSuccessMessage)
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            viewModel.isEditing = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                         to: nil,
                                         from: nil,
                                         for: nil)
        }
    }
}

#Preview {
    SendFeedbackView()
} 
