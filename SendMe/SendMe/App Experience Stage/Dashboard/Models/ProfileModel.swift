import Foundation

struct ProfileModel {
    var username: String
    var handle: String
    var friendCount: Int
    var isLoading: Bool
    var error: String?
    var selectedTab: ProfileTab
    
    enum ProfileTab {
        case activity
        case replies
        case media
    }
    
    static let initial = ProfileModel(
        username: "",
        handle: "",
        friendCount: 0,
        isLoading: false,
        error: nil,
        selectedTab: .activity
    )
} 