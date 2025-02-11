//
//  SignInView.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 01.01.25.
//

import UIKit

final class SignInView: UIViewController {
    private let viewModel = SignInViewModel()
    
    private let logoLabel = UILabel()
    private let imageContainerView = UIView()
    private let imageView = UIImageView()
    private let emailButton = UIButton(type: .system)
    private let emailIcon = UIImageView()
    private let orLabel = UILabel()
    private let appleButton = UIButton(type: .system)
    private let appleIcon = UIImageView()
    private let signInLabel = UILabel()
    private let signInButton = UIButton(type: .system)
    private let signInStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallbacks()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        logoLabel.text = "SendMe"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 28)
        logoLabel.textColor = .black
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.backgroundColor = .systemGray6
        imageContainerView.layer.cornerRadius = 20
        imageContainerView.clipsToBounds = true
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "image3")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(imageView)
        view.addSubview(imageContainerView)
        
        emailButton.setTitle("Continue with email", for: .normal)
        emailButton.setTitleColor(.white, for: .normal)
        emailButton.backgroundColor = .systemBlue
        emailButton.layer.cornerRadius = 25
        emailButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.addTarget(self, action: #selector(emailSignInTapped), for: .touchUpInside)
        
        emailIcon.image = UIImage(systemName: "envelope.fill")
        emailIcon.tintColor = .white
        emailIcon.translatesAutoresizingMaskIntoConstraints = false
        emailButton.addSubview(emailIcon)
        
        orLabel.text = "or"
        orLabel.textColor = .gray
        orLabel.font = .systemFont(ofSize: 15)
        orLabel.textAlignment = .center
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        
        appleButton.setTitle("Continue with Apple", for: .normal)
        appleButton.setTitleColor(.white, for: .normal)
        appleButton.backgroundColor = .black
        appleButton.layer.cornerRadius = 25
        appleButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        
        appleIcon.image = UIImage(systemName: "apple.logo")
        appleIcon.tintColor = .white
        appleIcon.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addSubview(appleIcon)
        
        signInLabel.text = "Already with us? "
        signInLabel.textColor = .gray
        signInLabel.font = .systemFont(ofSize: 15)
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(.systemBlue, for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        signInStack.addArrangedSubview(signInLabel)
        signInStack.addArrangedSubview(signInButton)
        signInStack.axis = .horizontal
        signInStack.spacing = 0
        signInStack.alignment = .center
        signInStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoLabel)
        view.addSubview(imageContainerView)
        view.addSubview(emailButton)
        view.addSubview(orLabel)
        view.addSubview(appleButton)
        view.addSubview(signInStack)
    }
    
    private func setupCallbacks() {
        viewModel.onNavigationRequested = { [weak self] action in
            switch action {
            case .emailSignUp:
                let emailSignUpView = EmailSignUpView()
                self?.navigationController?.pushViewController(emailSignUpView, animated: true)
            case .appleSignIn:
                break
            case .existingUserSignIn:
                let loginView = LoginView()
                let navigationController = UINavigationController(rootViewController: loginView)
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true)
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageContainerView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 15),
            imageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            emailButton.bottomAnchor.constraint(equalTo: orLabel.topAnchor, constant: -10),
            emailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailButton.heightAnchor.constraint(equalToConstant: 50),
            
            emailIcon.leadingAnchor.constraint(equalTo: emailButton.leadingAnchor, constant: 20),
            emailIcon.centerYAnchor.constraint(equalTo: emailButton.centerYAnchor),
            emailIcon.widthAnchor.constraint(equalToConstant: 25),
            emailIcon.heightAnchor.constraint(equalToConstant: 25),
            
            orLabel.bottomAnchor.constraint(equalTo: appleButton.topAnchor, constant: -10),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            appleButton.bottomAnchor.constraint(equalTo: signInStack.topAnchor, constant: -32),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            appleButton.heightAnchor.constraint(equalToConstant: 50),
            
            appleIcon.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 20),
            appleIcon.centerYAnchor.constraint(equalTo: appleButton.centerYAnchor),
            appleIcon.widthAnchor.constraint(equalToConstant: 20),
            appleIcon.heightAnchor.constraint(equalToConstant: 25),
            
            signInStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signInStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func emailSignInTapped() {
        viewModel.navigateToEmailSignUp()
    }
    
    @objc private func appleSignInTapped() {
        viewModel.handleAppleSignIn()
        let alert = UIAlertController(title: "Apple Sign In", message: "Apple sign-in is currently not available", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func signInTapped() {
        viewModel.handleExistingUserSignIn()
    }
    
}


