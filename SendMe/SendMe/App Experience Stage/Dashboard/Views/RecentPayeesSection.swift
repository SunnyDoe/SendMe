import SwiftUI

struct RecentPayeesSection: View {
    let transactions: [Transaction]
    
    private var uniquePayees: [Payee] {
        let payees = transactions.compactMap { transaction -> Payee? in
            guard !transaction.name.isEmpty else { return nil }
            return Payee(image: transaction.imageURL, name: transaction.name)
        }
        return Array(Set(payees)).prefix(6).map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent payees")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 24) {
                    ForEach(uniquePayees) { payee in
                        VStack(spacing: 8) {
                            if let imageURL = payee.image {
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray.opacity(0.3))
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                            
                            Text(payee.name)
                                .font(.subheadline)
                                .lineLimit(1)
                                .frame(width: 60)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 