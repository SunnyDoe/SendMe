import UIKit

class EmailSignUpView: UIViewController {
    
    private let viewModel = EmailSignUpViewModel()
    private var emailTextField: UITextField!
    private var continueButton: UIButton!
    private var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        emailTextField.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
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
        continueButton.setTitleColor(.gray, for: .normal)
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
    
    @objc private func emailTextChanged(_ textField: UITextField) {
        guard let email = textField.text else { return }
        viewModel.onStateChanged = { [weak self] state in
            self?.updateUI(with: state)
        }
        viewModel.validateEmail(email)
    }
    
    private func updateUI(with state: EmailSignUpViewModel.ViewState) {
        updateContinueButton(isEnabled: state.isButtonEnabled)
        
        if let errorMessage = state.errorMessage {
            showValidationError(errorMessage)
        } else {
            hideError()
        }
    }
    
    private func updateContinueButton(isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
        continueButton.backgroundColor = isEnabled ? .systemBlue : .systemGray5
        continueButton.setTitleColor(isEnabled ? .white : .gray, for: .normal)
    }
    
    @objc private func continueButtonTapped() {
        guard let email = emailTextField.text else { return }
        
        viewModel.handleContinue(withEmail: email) { [weak self] result in
            switch result {
            case .success:
                let passwordView = PasswordView(email: email)
                self?.navigationController?.pushViewController(passwordView, animated: true)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
