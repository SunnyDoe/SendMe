import UIKit

final class FaceIDSetupView: UIViewController {
    private let viewModel = FaceIDSetupViewModel()
    private var enableButton: UIButton!
    private let imageContainerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let laterButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        imageContainerView.backgroundColor = .systemGray6
        imageContainerView.layer.cornerRadius = 20
        imageContainerView.clipsToBounds = true
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "image2") {
            imageView.image = image
        } else {
            print("Error: Image 'image2' not found.")
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "image2")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.addSubview(imageView)
        
        titleLabel.text = viewModel.model.title ?? "Enable Face ID"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = viewModel.model.description ?? "Face ID is a convenient and secure method of signing into your account."
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        enableButton = UIButton(type: .system)
        enableButton.setTitle(viewModel.model.enableButtonTitle ?? "Enable Face ID", for: .normal)
        enableButton.setTitleColor(.white, for: .normal)
        enableButton.backgroundColor = .systemBlue
        enableButton.layer.cornerRadius = 25
        enableButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        enableButton.addTarget(self, action: #selector(enableFaceIDTapped), for: .touchUpInside)
        enableButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        laterButton.setTitle(viewModel.model.laterButtonTitle ?? "Maybe later", for: .normal)
        laterButton.setTitleColor(.systemBlue, for: .normal)
        laterButton.titleLabel?.font = .systemFont(ofSize: 17)
        laterButton.addTarget(self, action: #selector(maybeLaterTapped), for: .touchUpInside)
        laterButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageContainerView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(enableButton)
        view.addSubview(laterButton)
    }
    
    private func setupConstraints() {
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
            enableButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func enableFaceIDTapped() {
#warning("For Future Implementation")
        let alertController = UIAlertController(
            title: "Face ID Unavailable",
            message: "Face ID functionality is currently unavailable in this version. Please check back later.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func maybeLaterTapped() {
        let loginView = LoginView()
        let navigationController = UINavigationController(rootViewController: loginView)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
} 

#Preview {
    FaceIDSetupView()
}
