import UIKit

final class PasswordView: UIViewController {
    private let viewModel: PasswordViewModel
    private var passwordTextField: UITextField!
    private var continueButton: UIButton!
    private var criteriaStackView: UIStackView!
    private var criteriaLabels: [PasswordViewModel.PasswordCriteria: (UILabel, UIImageView)] = [:]
    
    init(email: String) {
        self.viewModel = PasswordViewModel(userEmail: email)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    
    private func setupNavigation() {
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Create your password"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.cornerRadius = 8
        
        let showPasswordButton = UIButton(type: .system)
        showPasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        showPasswordButton.tintColor = .systemGray
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.rightView = showPasswordButton
        passwordTextField.rightViewMode = .always
        
        criteriaStackView = UIStackView()
        criteriaStackView.axis = .vertical
        criteriaStackView.spacing = 16
        criteriaStackView.translatesAutoresizingMaskIntoConstraints = false
        
        PasswordViewModel.PasswordCriteria.allCases.forEach { criteria in
            let (stack, label, imageView) = createCriteriaView(criteria)
            criteriaStackView.addArrangedSubview(stack)
            criteriaLabels[criteria] = (label, imageView)
        }
        
        continueButton = UIButton(type: .system)
        continueButton.setTitle("Done", for: .normal)
        continueButton.setTitleColor(.gray, for: .normal)
        continueButton.backgroundColor = .systemGray5
        continueButton.layer.cornerRadius = 25
        continueButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(criteriaStackView)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            criteriaStackView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            criteriaStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            criteriaStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        viewModel.onStateChanged = { [weak self] state in
            self?.updateUI(with: state)
        }
    }
    
    private func createCriteriaView(_ criteria: PasswordViewModel.PasswordCriteria) -> (UIStackView, UILabel, UIImageView) {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemRed
        imageView.image = UIImage(systemName: "xmark.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = criteria.rawValue
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemRed
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return (stack, label, imageView)
    }
    
    @objc private func passwordTextChanged(_ textField: UITextField) {
        viewModel.validatePassword(textField.text ?? "")
    }
    
    @objc private func togglePasswordVisibility(_ button: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        button.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func updateUI(with state: PasswordViewModel.ViewState) {
        state.passwordCriteria.forEach { (criteria, isValid) in
            if let (label, imageView) = criteriaLabels[criteria] {
                imageView.image = UIImage(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                imageView.tintColor = isValid ? .systemGreen : .systemRed
                label.textColor = isValid ? .systemGreen : .systemRed
            }
        }
        
        continueButton.isEnabled = state.isButtonEnabled
        continueButton.backgroundColor = state.isButtonEnabled ? .systemBlue : .systemGray5
        continueButton.setTitleColor(state.isButtonEnabled ? .white : .gray, for: .normal)
    }
    
    @objc private func continueButtonTapped() {
        guard let password = passwordTextField.text else { return }
        
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.startAnimating()
        continueButton.setTitle("", for: .normal)
        continueButton.addSubview(loadingIndicator)
        loadingIndicator.center = continueButton.center
        
        viewModel.handleContinue(withPassword: password) { [weak self] result in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
                self?.continueButton.setTitle("Done", for: .normal)
                
                switch result {
                case .success:
                    self?.navigateToHome()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    private func navigateToHome() {
        let faceIDSetupView = FaceIDSetupView()
        let navigationController = UINavigationController(rootViewController: faceIDSetupView)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: PasswordView(email: "test@example.com"))
} 
