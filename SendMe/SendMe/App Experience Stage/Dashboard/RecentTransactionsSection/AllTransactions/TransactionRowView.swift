import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var loadingError = false
    
    var body: some View {
        HStack {
            if isLoading {
                ProgressView()
                    .frame(width: 40, height: 40)
            } else if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.name)
                    .font(.system(size: 16, weight: .medium))
                Text(transaction.formattedTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(transaction.formattedAmount)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(transaction.amount >= 0 ? .green : .red)
        }
        .padding(.vertical, 8)
        .onAppear {
            loadImage()
        }
        .alert(isPresented: $loadingError) {
            Alert(title: Text("Image Load Failed"),
                  message: Text("There was an error loading the image."),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func loadImage() {
            guard let imageURLString = transaction.imageURL,
                  let imageURL = URL(string: imageURLString) else {
                return
            }
            
            isLoading = true
            
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: imageURL)
                    guard let loadedImage = UIImage(data: data) else {
                        throw URLError(.badServerResponse)
                    }
                    self.image = loadedImage
                } catch {
                    loadingError = true
                    print("Error loading image: \(error.localizedDescription)")
                }
                isLoading = false
            }
        }
    }
