import SwiftUI
import PhotosUI
import FirebaseAuth

struct EditProfileView: View {
    @StateObject private var viewModel = EditProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                VStack(spacing: 12) {
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
                    
                    Button("Edit avatar") {
                        viewModel.showingActionSheet = true
                    }
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            
            Section {
                TextField("First name", text: Binding(
                    get: { viewModel.state.firstName },
                    set: { viewModel.updateProfile(firstName: $0) }
                ))
                
                TextField("Last name", text: Binding(
                    get: { viewModel.state.lastName },
                    set: { viewModel.updateProfile(lastName: $0) }
                ))
                
                TextField("Email address", text: Binding(
                    get: { viewModel.state.email },
                    set: { viewModel.updateProfile(email: $0) }
                ))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disabled(true)
                .foregroundColor(.gray)
                .onAppear {
                    if let currentUser = Auth.auth().currentUser {
                        viewModel.updateProfile(email: currentUser.email ?? "")
                    }
                }
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                )
                
                NavigationLink {
                    CountrySelectionView(selectedCountry: Binding(
                        get: { viewModel.state.country },
                        set: { viewModel.updateProfile(country: $0) }
                    ))
                } label: {
                    HStack {
                        Text("Country of residence")
                        Spacer()
                        Text(viewModel.state.country)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Edit profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    dismiss()
                }
                .disabled(viewModel.state.isLoading)
            }
        }
        .confirmationDialog("Change profile photo", isPresented: $viewModel.showingActionSheet) {
            Button("Take Photo") {
                viewModel.showingImagePicker = true
            }
            Button("Choose from Library") {
                viewModel.showingImagePicker = true
            }
            if viewModel.state.avatar != nil {
                Button("Remove Current Photo", role: .destructive) {
                    viewModel.updateAvatar(nil)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: Binding(
                get: { viewModel.state.avatar },
                set: { viewModel.updateAvatar($0) }
            ))
        }
    }
}
