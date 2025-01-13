import UIKit

final class EmailSignUpView: UIViewController {
    
    private let viewModel = EmailSignUpViewModel()
    private var emailTextField: UITextField!
    private var continueButton: UIButton!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallbacks()
        setupNavigation()
    }
    
    private func setupNavigation() {
        navigationItem.title = ""
        
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.hidesBackButton = false
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Enter your email\naddress"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Email Address"
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .systemBackground
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let termsText = UILabel()
        termsText.text = "By tapping on continue button, you accept our"
        termsText.textColor = .gray
        termsText.font = .systemFont(ofSize: 13)
        termsText.translatesAutoresizingMaskIntoConstraints = false
        
        let termsButton = UIButton(type: .system)
        termsButton.setTitle("Terms of Use", for: .normal)
        termsButton.titleLabel?.font = .systemFont(ofSize: 13)
        
        let andLabel = UILabel()
        andLabel.text = "and"
        andLabel.textColor = .gray
        andLabel.font = .systemFont(ofSize: 13)
        
        let privacyButton = UIButton(type: .system)
        privacyButton.setTitle("Privacy Policy.", for: .normal)
        privacyButton.titleLabel?.font = .systemFont(ofSize: 13)
        
        let termsStack = UIStackView(arrangedSubviews: [termsButton, andLabel, privacyButton])
        termsStack.axis = .horizontal
        termsStack.spacing = 4
        termsStack.alignment = .center
        termsStack.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemGray5
        continueButton.layer.cornerRadius = 25
        continueButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        continueButton.isEnabled = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        errorLabel = UILabel()
        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.alpha = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(termsText)
        view.addSubview(termsStack)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            termsText.bottomAnchor.constraint(equalTo: termsStack.topAnchor, constant: -4),
            termsText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            termsStack.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24),
            termsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            errorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
        ])
    }
    
    private func setupCallbacks() {
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateUI(with: state)
            }
        }
    }
    
    private func updateUI(with state: EmailSignUpModel) {
        if state.isLoading {
            activityIndicator.startAnimating()
            continueButton.setTitle("", for: .normal)
            continueButton.addSubview(activityIndicator)
            activityIndicator.center = continueButton.center
        } else {
            activityIndicator.removeFromSuperview()
            continueButton.setTitle("Continue", for: .normal)
        }
        
        continueButton.isEnabled = state.isEmailValid
        continueButton.backgroundColor = state.isEmailValid ? .systemBlue : .systemGray5
        
        if let error = state.error {
            showValidationError(error)
        } else {
            hideError()
        }
    }
    
    @objc private func emailChanged(_ textField: UITextField) {
        guard let email = textField.text else { return }
        viewModel.validateEmail(email)
    }
    
    @objc private func continueButtonTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            showValidationError("Please enter your email address")
            return
        }
        
        if !email.contains("@") || !email.contains(".") {
            showValidationError("Please enter a valid email address")
            return
        }
        
        viewModel.checkEmailAvailability(email)
        
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateUI(with: state)
                
                if !state.isLoading && state.canProceed && state.error == nil {
                    self?.navigateToPasswordScreen()
                }
            }
        }
    }
    
    private func navigateToPasswordScreen() {
        guard let email = emailTextField.text else { return }
        let passwordView = PasswordView(email: email)
        navigationController?.pushViewController(passwordView, animated: true)
    }
    
    private func showValidationError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.errorLabel.alpha = 1
            self.emailTextField.layer.borderColor = UIColor.systemRed.cgColor
            self.emailTextField.layer.borderWidth = 1
        }
    }
    
    private func hideError() {
        UIView.animate(withDuration: 0.3) {
            self.errorLabel.alpha = 0
            self.emailTextField.layer.borderWidth = 0
        } completion: { _ in
            self.errorLabel.isHidden = true
        }
    }
}

#Preview {
    UINavigationController(rootViewController: EmailSignUpView())
}
