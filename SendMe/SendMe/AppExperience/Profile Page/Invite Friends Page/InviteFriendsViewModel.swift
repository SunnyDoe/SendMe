//
//  InviteFriendsViewModel.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 31.01.25.
//

import Foundation
import UIKit

@MainActor
final class InviteFriendsViewModel: ObservableObject {
    @Published var inviteLink: String = ""
    
    init() {
        generateInviteLink()
    }
    
    private func generateInviteLink() {
        let uniqueCode = UUID().uuidString.prefix(8)
        inviteLink = "https://sendme.app/invite/\(uniqueCode)"
    }
    
    func copyLink() {
        UIPasteboard.general.string = inviteLink

        }
    }
