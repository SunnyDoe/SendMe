import Foundation

class AddCardViewModel: ObservableObject {
    @Published var cardName = ""
    @Published var cardNumber = ""
    @Published var expiryDate = ""
    @Published var cvc = ""
    @Published var cardBrand: CardBrand = .unknown
    
    @Published var cardNameError: String?
    @Published var cardNumberError: String?
    @Published var expiryDateError: String?
    @Published var cvcError: String?
    @Published var isFormValid = false
    
    private let cardNumberRegex = "^[0-9]{16}$"
    private let expiryDateRegex = "^(0[1-9]|1[0-2])/([0-9]{2})$"
    private let cvcRegex = "^[0-9]{3,4}$"
    
    func validateForm() {
        validateCardName()
        validateCardNumber()
        validateExpiryDate()
        validateCVC()
        
        isFormValid = cardNameError == nil &&
                     cardNumberError == nil &&
                     expiryDateError == nil &&
                     cvcError == nil &&
                     !cardName.isEmpty &&
                     !cardNumber.isEmpty &&
                     !expiryDate.isEmpty &&
                     !cvc.isEmpty
    }
    
    private func validateCardName() {
        cardNameError = cardName.isEmpty ? "Name is required" :
                       cardName.count < 2 ? "Name is too short" : nil
    }
    
    private func validateCardNumber() {
        let cleaned = cardNumber.replacingOccurrences(of: " ", with: "")
        if cleaned.isEmpty {
            cardNumberError = "Card number is required"
        } else if cleaned.count != 16 {
            cardNumberError = "Card number must be 16 digits"
        } else if !isLuhnValid(cleaned) {
            cardNumberError = "Invalid card number"
        } else {
            cardNumberError = nil
        }
    }
    
    private func validateExpiryDate() {
        if expiryDate.isEmpty {
            expiryDateError = "Expiry date is required"
            return
        }
        
        if !expiryDate.matches(pattern: expiryDateRegex) {
            expiryDateError = "Use MM/YY format"
            return
        }
        
        let components = expiryDate.split(separator: "/")
        if components.count == 2,
           let month = Int(components[0]),
           let year = Int(components[1]) {
            let currentYear = Calendar.current.component(.year, from: Date()) % 100
            let currentMonth = Calendar.current.component(.month, from: Date())
            
            if year < currentYear || (year == currentYear && month < currentMonth) {
                expiryDateError = "Card has expired"
            } else {
                expiryDateError = nil
            }
        }
    }
    
    private func validateCVC() {
        cvcError = cvc.isEmpty ? "CVC is required" :
                  !cvc.matches(pattern: cvcRegex) ? "Invalid CVC" : nil
    }
    
    private func isLuhnValid(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1
                
                switch (odd, digit) {
                case (true, 9): sum += 9
                case (true, 0...8): sum += (digit * 2) % 9
                default: sum += digit
                }
            }
        }
        return sum % 10 == 0
    }
    
    func formatExpiryDate(_ input: String) {
        let cleaned = input.filter { $0.isNumber }
        if cleaned.count <= 4 {
            if cleaned.count >= 2 {
                let month = cleaned.prefix(2)
                let year = cleaned.dropFirst(2)
                expiryDate = "\(month)/\(year)"
            } else {
                expiryDate = cleaned
            }
        }
    }
    
    func formatCardNumber(_ input: String) {
        let cleaned = input.filter { $0.isNumber }
        if cleaned.count <= 16 {
            var formatted = ""
            for (index, char) in cleaned.enumerated() {
                if index > 0 && index % 4 == 0 {
                    formatted += " "
                }
                formatted += String(char)
            }
            cardNumber = formatted
            
            if cleaned.count >= 2 {
                cardBrand = CardBrand.identify(from: cleaned)
            } else {
                cardBrand = .unknown
            }
        }
    }
}

private extension String {
    func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression) != nil
    }
} 