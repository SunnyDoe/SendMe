//
//  SplashViewModel.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 01.01.25.
//

import Foundation

final class SplashViewModel {
    var onSplashComplete: (() -> Void)?
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.onSplashComplete?()
        }
    }
}
