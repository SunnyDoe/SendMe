import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            if let avatar = viewModel.state.avatar {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .accessibilityLabel("Profile picture")
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .accessibilityLabel("Default profile picture")
            }
            
            VStack(spacing: 8) {
                Text(viewModel.state.username)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(viewModel.state.handle)
                    .foregroundColor(.gray)
            }
            .padding(.bottom)
            
            List {
                NavigationLink(destination: UpgradeView()) {
                    SettingsRow(icon: "star", title: "Upgrade", iconColor: .yellow)
                }
                
                NavigationLink(destination: EditProfileView()) {
                    SettingsRow(icon: "person", title: "Edit profile")
                }
                
                NavigationLink(destination: PaymentMethodsView()) {
                    SettingsRow(icon: "creditcard", title: "Payment methods")
                }
                
                NavigationLink(destination: SecurityNotificationsView()) {
                    SettingsRow(icon: "lock", title: "Security & Notifications")
                }
                
                NavigationLink(destination: InviteFriendsView()) {
                    SettingsRow(icon: "person.2", title: "Invite friends")
                        .accessibilityHint("Invite friends and earn rewards")
                }
                
                NavigationLink(destination: SendFeedbackView()) {
                    SettingsRow(icon: "bubble.left", title: "Send feedback")
                }
                
                NavigationLink(destination: Text("Rate us")) {
                    SettingsRow(icon: "star", title: "Rate us")
                }
                
                Button(action: {
                    viewModel.signOut()
                }) {
                    SettingsRow(icon: "arrow.right.square", title: "Sign out", textColor: .red)
                        .accessibilityLabel("Sign out")
                        .accessibilityHint("Sign out of your account")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.white)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { viewModel.showingPrivacySettings = true }) {
                    Image(systemName: "globe")
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditProfileView()) {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $viewModel.showingPrivacySettings) {
            PrivacySettingsView()
        }
    }
}



#Preview {
    NavigationView {
        ProfileView()
    }
}
