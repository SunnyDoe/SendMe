import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) { 
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                    
                    Text(viewModel.state.username)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(viewModel.state.handle)
                        .foregroundColor(.gray)
                    
                    Text("\(viewModel.state.friendCount) friends")
                        .padding(.top, 4)
                }
                .padding(.top)
                
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Text("Upgrade")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    
                    Button(action: {}) {
                        Text("Settings")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(.systemGray6))
                            .cornerRadius(25)
                    }
                }
                .padding()
                
                HStack(spacing: 0) {
                    ForEach([
                        (ProfileModel.ProfileTab.activity, "Activity"),
                        (ProfileModel.ProfileTab.replies, "Replies"),
                        (ProfileModel.ProfileTab.media, "Media")
                    ], id: \.0) { tab, title in
                        Button(action: { viewModel.selectTab(tab) }) {
                            VStack(spacing: 8) {
                                Text(title)
                                    .foregroundColor(viewModel.state.selectedTab == tab ? .blue : .gray)
                                
                                Rectangle()
                                    .fill(viewModel.state.selectedTab == tab ? Color.blue : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                    
                    Text("Nothing found")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Check back later")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}
