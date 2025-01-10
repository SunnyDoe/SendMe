import UIKit
import SwiftUI
import FirebaseAuth

final class LoginView: UIViewController {
    private let viewModel = LoginViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var emailField: UITextField!
    private var passwordField: UITextField!
    private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallbacks()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let logoLabel = UILabel()
        logoLabel.text = "SendMe"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 28)
        logoLabel.textColor = .black
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let imageContainerView = UIView()
        imageContainerView.backgroundColor = .systemGray6
        imageContainerView.layer.cornerRadius = 20
        imageContainerView.clipsToBounds = true
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "image3")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Welcome Back"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 25
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addSubview(activityIndicator)
        
        view.addSubview(logoLabel)
        view.addSubview(imageContainerView)
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageContainerView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 20),
            imageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
    }
    
    private func setupCallbacks() {
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                if state.isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.loginButton.isEnabled = false
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.loginButton.isEnabled = true
                }
                
                if let error = state.error {
                    self?.showError(error)
                }
            }
        }
        
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToMainApp()
            }
        }
    }
    
    private func navigateToMainApp() {
        let dashboardView = UIHostingController(rootView: DashboardView())
        dashboardView.modalPresentationStyle = .fullScreen
        present(dashboardView, animated: true)
    }
    
    @objc private func loginTapped() {
        view.endEditing(true)
        
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showError("Please fill in all fields")
            return
        }
        
        if email.isEmpty || password.isEmpty {
            showError("Please fill in all fields")
            return
        }
        viewModel.login(email: email, password: password)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 

#Preview {
    LoginView()
}
