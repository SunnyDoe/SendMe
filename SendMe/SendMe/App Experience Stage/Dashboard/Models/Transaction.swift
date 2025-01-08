import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    let image: String?
    let title: String
    let time: String
    let amount: String
    
    init(image: String? = nil, title: String, time: String, amount: String) {
        self.image = image
        self.title = title
        self.time = time
        self.amount = amount
    }
} 