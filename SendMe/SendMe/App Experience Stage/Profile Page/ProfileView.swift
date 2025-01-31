import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showLogoutAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let avatar = viewModel.state.avatar {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 8) {
                Text(viewModel.state.username)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.bottom)
            
            List {
                NavigationLink(destination: UpgradeView()) {
                    SettingsRow(icon: "star", title: "Upgrade", iconColor: .yellow)
                }
                
                NavigationLink(destination: EditProfileView()) {
                    SettingsRow(icon: "person", title: "Edit profile")
                }
                
                NavigationLink(destination: PaymentMethodsView(viewModel: PaymentMethodsViewModel())) {
                    SettingsRow(icon: "creditcard", title: "Payment methods")
                    
                }
                
                NavigationLink(destination: SecurityNotificationsView()) {
                    SettingsRow(icon: "lock", title: "Security & Notifications")
                }
                
                NavigationLink(destination: InviteFriendsView()) {
                    SettingsRow(icon: "person.2", title: "Invite friends")
                }
                
                NavigationLink(destination: SendFeedbackView()) {
                    SettingsRow(icon: "bubble.left", title: "Send feedback")
                }
                
                NavigationLink(destination: RatingView()) {
                    SettingsRow(icon: "star", title: "Rate us")
                }
                
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                        Text("Log out")
                            .foregroundColor(.red)
                    }
                }
                .alert("Log out", isPresented: $showLogoutAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Log out", role: .destructive) {
                        viewModel.signOut()
                    }
                } message: {
                    Text("Are you sure you want to log out?")
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
