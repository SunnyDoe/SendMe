import SwiftUI

struct ChatView: View {
    let user: User
    @StateObject private var viewModel = ChatViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showActionSheet = false
    @State private var showRequestMoneyView = false
    @State private var showSendMoneyView = false
    @State private var shouldRefresh = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                
                Text(user.fullName)
                    .font(.system(size: 17, weight: .semibold))
                
                Spacer()
                
                Button(action: { showActionSheet = true }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                .padding(.trailing, 8)
                
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
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack(spacing: 12) {
                TextField("Type a message...", text: $viewModel.messageText)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Button(action: {
                    Task {
                        await viewModel.sendMessage()
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
        .task {
            await viewModel.fetchMessages(for: user.id)
        }
        .onChange(of: shouldRefresh) { _ in
            Task {
                await viewModel.fetchMessages(for: user.id)
                shouldRefresh = false
            }
        }
        .confirmationDialog("", isPresented: $showActionSheet, titleVisibility: .hidden) {
            Button("Send money") {
                showSendMoneyView = true
            }
            
            Button("Request money") {
                showRequestMoneyView = true
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showSendMoneyView) {
            SendMoneyView(user: user, onCompletion: {
                shouldRefresh = true
            })
        }
        .sheet(isPresented: $showRequestMoneyView) {
            RequestMoneyView(user: user, onCompletion: {
                shouldRefresh = true
            })
        }
    }
}
