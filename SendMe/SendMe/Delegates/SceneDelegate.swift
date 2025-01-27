//
//  SceneDelegate.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 01.01.25.
//

import UIKit
import FirebaseAuth
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        if Auth.auth().currentUser != nil {
            showDashboard(in: window)
        } else if let credentials = LoginViewModel().getStoredCredentials() {
            LoginViewModel().login(email: credentials.email, password: credentials.password)
            showDashboard(in: window)
        } else {
            showSignInScreen(in: window)
        }

        self.window = window
        window.makeKeyAndVisible()
    }

    private func showDashboard(in window: UIWindow) {
        let dashboardView = DashboardView()
        let hostingController = UIHostingController(rootView: dashboardView)
        window.rootViewController = hostingController
    }

    private func showSignInScreen(in window: UIWindow) {
        let signInView = SplashViewController()
        let navigationController = UINavigationController(rootViewController: signInView)
        window.rootViewController = navigationController
    }
}


