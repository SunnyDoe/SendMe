import SwiftUI

struct SecurityNotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SecurityNotificationsViewModel()
    @State private var showToast = false
    
    var body: some View {
        List {
            Section("Security") {
                NavigationLink {
                    ChangePasswordView()
                } label: {
                    HStack {
                        Image(systemName: "lock")
                            .frame(width: 24)
                        Text("Change password")
                    }
                }
                
                HStack {
                    Image(systemName: "faceid")
                        .frame(width: 24)
                    Text("Sign in with Face ID")
                    Spacer()
                    Toggle("Face ID Authentication", isOn: $viewModel.isFaceIDEnabled)
                        .disabled(true)
                        .tint(.gray)
                        .onTapGesture {
                            viewModel.toggleFaceID()
                        }
                        .accessibilityHint("Face ID authentication is currently unavailable")
                }
            }
            
            Section("Marketing") {
                MarketingToggleView(
                    icon: "bell",
                    title: "Personalised pushes",
                    description: viewModel.pushDescription,
                    isEnabled: $viewModel.isPushEnabled
                )
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Personalised push notifications")
                .accessibilityHint("Toggle to receive personalized push notifications")
                
                MarketingToggleView(
                    icon: "message",
                    title: "Personalised texts",
                    description: viewModel.textDescription,
                    isEnabled: $viewModel.isTextEnabled
                )
                
                MarketingToggleView(
                    icon: "envelope",
                    title: "Personalised emails",
                    description: viewModel.emailDescription,
                    isEnabled: $viewModel.isEmailEnabled
                )
            }
        }
        .navigationTitle("Security & Notifications")
        .navigationBarTitleDisplayMode(.inline)
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
        .toast(isShowing: $showToast, message: "Password was successfully changed")
        .onReceive(NotificationCenter.default.publisher(for: .passwordChanged)) { _ in
            showToast = true
        }
        .alert("Face ID Unavailable", isPresented: $viewModel.showFaceIDAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Face ID functionality is currently unavailable in this version. Please check back later.")
        }
    }
}
