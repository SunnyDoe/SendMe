import SwiftUI

struct PrivacySettingsView: View {
    @StateObject private var viewModel = PrivacySettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Privacy")) {
                    ForEach(PrivacySettingsModel.PrivacyLevel.allCases, id: \.self) { level in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(level.rawValue)
                                    .font(.body)
                                Text(level.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if viewModel.state.selectedPrivacyLevel == level {
                                if viewModel.state.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Circle()
                                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.updatePrivacyLevel(level)
                        }
                        .disabled(viewModel.state.isLoading)
                    }
                }
                
                Section(footer: Text("Select your default privacy setting for all future payments. You can also change it for each payment individually.")) {
                    EmptyView()
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
} 
