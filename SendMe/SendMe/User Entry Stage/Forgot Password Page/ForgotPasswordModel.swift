//
//  ForgotPasswordModel.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 14.01.25.
//

import Foundation

struct ForgotPasswordModel {
    var isLoading: Bool
    var error: String?
    var isSuccess: Bool
    
    static let initial = ForgotPasswordModel(isLoading: false, error: nil, isSuccess: false)
} 
