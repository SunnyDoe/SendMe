import Foundation

struct Payee: Identifiable, Hashable {
    let id = UUID()
    let image: String?
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Payee, rhs: Payee) -> Bool {
        return lhs.id == rhs.id
    }
} 