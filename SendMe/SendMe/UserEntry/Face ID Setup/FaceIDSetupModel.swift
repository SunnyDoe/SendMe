import Foundation

struct FaceIDSetupModel {
    let title: String? = "Enable Face ID"
    let description: String? = "Face ID is a convenient and secure method of signing into your account."
    let enableButtonTitle: String? = "Enable Face ID"
    let laterButtonTitle: String? = "Maybe later"
    var isFaceIDEnabled: Bool? = false
    var error: String?
    
    var isLoading: Bool = false
} 
