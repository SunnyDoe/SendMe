import SwiftUI

enum CardBrand: String {
    case visa = "visa"
    case mastercard = "mastercard"
    case amex = "amex"
    case discover = "discover"
    case unknown = "unknown"
    
    var logo: Image {
        switch self {
        case .visa:
            return Image("visa_logo")
        case .mastercard:
            return Image("mastercard_logo")
        case .amex:
            return Image("amex_logo")
        case .discover:
            return Image("discover_logo")
        case .unknown:
            return Image(systemName: "creditcard")
        }
    }
    
    static func identify(from number: String) -> CardBrand {
        let prefix = String(number.prefix(2))
        
        switch prefix {
        case let x where x.hasPrefix("4"):
            return .visa
        case let x where x.hasPrefix("5"):
            return .mastercard
        case let x where x.hasPrefix("34"), let x where x.hasPrefix("37"):
            return .amex
        case let x where x.hasPrefix("6"):
            return .discover
        default:
            return .unknown
        }
    }
}
