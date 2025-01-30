import UIKit

final class FaceIDSetupView: UIViewController {
    private let viewModel = FaceIDSetupViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var enableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let imageContainerView = UIView()
        imageContainerView.backgroundColor = .systemGray6
        imageContainerView.layer.cornerRadius = 20
        imageContainerView.clipsToBounds = true
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "image2")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = viewModel.model.title
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = viewModel.model.description
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        enableButton = UIButton(type: .system)
        enableButton.setTitle(viewModel.model.enableButtonTitle, for: .normal)
        enableButton.setTitleColor(.white, for: .normal)
        enableButton.backgroundColor = .systemBlue
        enableButton.layer.cornerRadius = 25
        enableButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        enableButton.addTarget(self, action: #selector(enableFaceIDTapped), for: .touchUpInside)
        enableButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        enableButton.addSubview(activityIndicator)
        
        let laterButton = UIButton(type: .system)
        laterButton.setTitle(viewModel.model.laterButtonTitle, for: .normal)
        laterButton.setTitleColor(.systemBlue, for: .normal)
        laterButton.titleLabel?.font = .systemFont(ofSize: 17)
        laterButton.addTarget(self, action: #selector(maybeLaterTapped), for: .touchUpInside)
        laterButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageContainerView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(enableButton)
        view.addSubview(laterButton)
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            enableButton.bottomAnchor.constraint(equalTo: laterButton.topAnchor, constant: -16),
            laterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            laterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enableButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            enableButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            enableButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: enableButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: enableButton.centerYAnchor)
        ])
    }
    

    
    @objc private func enableFaceIDTapped() {
#warning("For Future Implementation")
    }
    
    @objc private func maybeLaterTapped() {
        let loginView = LoginView()
        let navigationController = UINavigationController(rootViewController: loginView)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 

