import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChangePasswordViewModel()
    @State private var showSuccessAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Change password")
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.bottom, 32)
            
            VStack(spacing: 20) {
                SecureField("Current password", text: $viewModel.currentPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textContentType(.password)
                
                SecureField("New password", text: $viewModel.newPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textContentType(.newPassword)
                
                SecureField("Re-enter new password", text: $viewModel.confirmPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textContentType(.newPassword)
            }
            .padding(.bottom, 24)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Password requirements:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)
                
                ForEach(Array(viewModel.passwordCriteria.keys), id: \.self) { criteria in
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.passwordCriteria[criteria] ?? false ? 
                              "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(viewModel.passwordCriteria[criteria] ?? false ? 
                                           .green : .red)
                        Text(criteria.rawValue)
                            .font(.subheadline)
                            .foregroundColor(viewModel.passwordCriteria[criteria] ?? false ? 
                                           .green : .red)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 16)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom, 16)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.changePassword()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Change password")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(25)
            .padding(.bottom, 32)
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .passwordChanged)) { _ in
            dismiss()
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your password has been successfully changed.")
        }
    }
}

#Preview {
    NavigationView {
        ChangePasswordView()
    }
} 
