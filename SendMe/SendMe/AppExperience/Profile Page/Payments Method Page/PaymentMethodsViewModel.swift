import Foundation

final class PaymentMethodsViewModel: ObservableObject {
    @Published var savedCards: [SavedCard] = []
    private var notificationObserver: NSObjectProtocol?
    
    init() {
        loadSavedCards()
        
        notificationObserver = NotificationCenter.default.addObserver(
            forName: .cardAdded,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let card = notification.userInfo?["card"] as? SavedCard {
                self?.savedCards.insert(card, at: 0)
                self?.saveCardsToKeychain()
            }
        }
    }
    
    func loadSavedCards() {
        do {
            savedCards = try KeychainManager.shared.loadCards()
        } catch {
            print("Failed to load cards: \(error)")
        }
    }
    
    private func saveCardsToKeychain() {
        do {
            try KeychainManager.shared.saveCards(savedCards)
        } catch {
            print("Failed to save cards: \(error)")
        }
    }
    
    func removeCard(_ card: SavedCard) {
        if let index = savedCards.firstIndex(where: { $0.id == card.id }) {
            savedCards.remove(at: index)
            saveCardsToKeychain()
        }
    }
    
    deinit {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
