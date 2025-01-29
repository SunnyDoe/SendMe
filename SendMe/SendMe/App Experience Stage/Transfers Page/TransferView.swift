import SwiftUI

struct TransferView: View {
    @StateObject private var viewModel = TransferViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Chat & Transfer")
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search by name,last name ", text: $viewModel.searchText)
                    .autocapitalization(.none)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                List(viewModel.filteredUsers) { user in
                    NavigationLink(destination: ChatView(user: user)) {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: user.profilePic)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.system(size: 17))
                                
                                Text(user.recentMessage)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Text(formatDate(user.recentMessageTime))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .task {
            await viewModel.fetchUsers()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    TransferView()
}
