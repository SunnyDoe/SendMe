import Foundation
import FirebaseFirestore

struct User: Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let profilePic: String
    let recentMessage: String
    let recentMessageTime: Date
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    init?(id: String, data: [String: Any]) {
        guard let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let profilePic = data["profilePic"] as? String,
              let recentMessage = data["recentMessage"] as? String,
              let timestamp = data["recentMessageTime"] as? Timestamp else {
            print("Failed to initialize User. Missing or invalid data:")
            print("firstName: \(data["firstName"] ?? "nil")")
            print("lastName: \(data["lastName"] ?? "nil")")
            print("profilePic: \(data["profilePic"] ?? "nil")")
            print("recentMessage: \(data["recentMessage"] ?? "nil")")
            print("recentMessageTime: \(data["recentMessageTime"] ?? "nil")")
            return nil
        }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.recentMessage = recentMessage
        self.recentMessageTime = timestamp.dateValue()
    }
}
