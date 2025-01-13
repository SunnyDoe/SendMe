//
//  GetStartedViewmodel.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 01.01.25.
//

import UIKit

final class GetStartedViewModel {
    var onGetStarted: (() -> Void)?
    
    func proceed() {
        onGetStarted?()
    }
    
    func navigateToSignIn(completion: @escaping (UINavigationController) -> Void) {
        let signInView = SignInView()
        let navigationController = UINavigationController(rootViewController: signInView)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .flipHorizontal
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        completion(navigationController)
    }
}
