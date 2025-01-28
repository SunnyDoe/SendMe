import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    @State private var image: UIImage?
    @State private var isLoading = false
    
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
    }
    
    private func loadImage() {
        guard let imageURLString = transaction.imageURL,
              let imageURL = URL(string: imageURLString) else {
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            isLoading = false
            
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let loadedImage = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }.resume()
    }
} 
