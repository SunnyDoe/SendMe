import Foundation

struct SavedCard: Identifiable, Codable {
    var id = UUID()
    let brand: CardBrand
    let lastFourDigits: String
    let expiryDate: String
}

extension CardBrand: Codable { } 
