import UIKit
import FirebaseAuth

final class ForgotPasswordView: UIViewController {
    private let viewModel = ForgotPasswordViewModel()
    private var emailTextField: UITextField!
    private var resetButton: UIButton!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallbacks()
        setupNavigation()
    }
    
    private func setupNavigation() {
        title = "Reset Password"
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Forgot your password?"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Enter your email address and we'll send you a link to reset your password"
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        resetButton = UIButton(type: .system)
        resetButton.setTitle("Send Reset Link", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = .systemBlue
        resetButton.layer.cornerRadius = 25
        resetButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addSubview(activityIndicator)
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor)
        ])
    }
    
    private func setupCallbacks() {
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                if state.isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.resetButton.isEnabled = false
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.resetButton.isEnabled = true
                }
                
                if let error = state.error {
                    self?.showError(error)
                }
                
                if state.isSuccess {
                    self?.showSuccess()
                }
            }
        }
    }
    
    @objc private func resetButtonTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            showError("Please enter your email address")
            return
        }
        
        viewModel.resetPassword(email: email)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccess() {
        let alert = UIAlertController(
            title: "Success",
            message: "Password reset link has been sent to your email",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
} 

#Preview {
    ForgotPasswordView()
}
