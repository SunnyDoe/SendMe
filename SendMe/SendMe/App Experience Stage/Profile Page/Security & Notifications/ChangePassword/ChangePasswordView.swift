import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChangePasswordViewModel()
    @State private var showSuccessAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Change password")
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            VStack(spacing: 16) {
                SecureField("Current password", text: $viewModel.currentPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.password)
                
                SecureField("New password", text: $viewModel.newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.newPassword)
                
                SecureField("Re-enter new password", text: $viewModel.confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.newPassword)
            }
            
            // Password criteria list
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(viewModel.passwordCriteria.keys), id: \.self) { criteria in
                    HStack {
                        Image(systemName: viewModel.passwordCriteria[criteria] ?? false ? 
                              "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(viewModel.passwordCriteria[criteria] ?? false ? 
                                           .green : .red)
                        Text(criteria.rawValue)
                            .font(.caption)
                            .foregroundColor(viewModel.passwordCriteria[criteria] ?? false ? 
                                           .green : .red)
                    }
                }
            }
            .padding(.vertical)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                viewModel.changePassword()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Change password")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            
            Spacer()
        }
        .padding()
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
            showSuccessAlert = true
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
