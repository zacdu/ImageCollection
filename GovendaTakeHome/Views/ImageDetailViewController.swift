//
//  ImageDetailViewController.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

/// `ImageDetailViewController` is a subclass of `UIViewController` that displays detailed information about an Unsplash image.
/// It uses a `UIScrollView` to allow the user to scroll through the content, which is especially useful when the content height exceeds the screen height.
class ImageDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The `UnsplashImage` instance that the view controller displays. This property is set when the view controller is initialized.
    var imageRepresented: ImageRepresentable
    
    /// The `ImageDetailViewModel` instance that the view controller uses to fetch images. This property is set when the view controller is initialized.
    /// The view controller delegates the task of fetching images to the view model, following the MVVM design pattern.
    var detailViewModel: ImageDetailViewModel
    
    // MARK: - UI Elements
    
    /// The `UIScrollView` instance that allows the user to scroll through the content.
    /// It contains the `imageView`, `usernameLabel`, `descriptionLabel`, `profileImageView`, and `socialMediaLabel`.
    let scrollView: UIScrollView
    
    /// The `UIImageView` instance that displays the Unsplash image.
    /// The view controller fetches the image from the Unsplash API and sets it as the `image` property of the `imageView`.
    let imageView: UIImageView
    
    /// The `UILabel` instance that displays the description of the Unsplash image.
    /// The text is set to the `description` property of the `unsplashImage`.
    let descriptionLabel: UILabel
    
    /// The `UILabel` instance that displays the username of the Unsplash image's user.
    /// The text is set to the `name` property of the `user` property of the `unsplashImage`.
    let usernameLabel: UILabel
    
    /// The `UIImageView` instance that displays the profile image of the Unsplash image's user.
    /// The view controller fetches the profile image from the Unsplash API and sets it as the `image` property of the `profileImageView`.
    let profileImageView: UIImageView
    
    /// The `UILabel` instance that displays the social media handle of the Unsplash image's user.
    /// The text is set to the `username` property of the `user` property of the `unsplashImage`, prefixed with "@".
    let socialMediaLabel: UILabel

    // MARK: - Initializer
    
    /// Creates a new `ImageDetailViewController` instance for the specified Unsplash image.
    ///
    /// - Parameters:
    ///   - unsplashImage: The Unsplash image to display.
    ///   - service: The service to use to fetch images.
    /// The initializer also creates a new `ImageDetailViewModel` instance with the specified service.
    init(image: ImageRepresentable, service: NetworkImageService) {
        self.imageRepresented = image
        self.detailViewModel = ImageDetailViewModel(service: service)
        
        self.scrollView = ImageDetailViewControllerUI.scrollView
        self.imageView = ImageDetailViewControllerUI.imageView
        self.descriptionLabel = ImageDetailViewControllerUI.descriptionLabel
        self.usernameLabel = ImageDetailViewControllerUI.usernameLabel
        self.profileImageView = ImageDetailViewControllerUI.profileImageView
        self.socialMediaLabel = ImageDetailViewControllerUI.socialMediaLabel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    /// Sets up the UI and fetches the Unsplash image and the profile image.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the UI
        setupUI()
        
        // Fetch the image and profile image
        loadImage()
        loadProfileImage()
        
        // Set the username, description, and social media handle
        usernameLabel.text = imageRepresented.username ?? "Unknown"
        descriptionLabel.text = imageRepresented.description ?? "No description"
        socialMediaLabel.text = "@\(imageRepresented.socialMedia ?? "")"
    }
    
}



// MARK: - Image Model methods
extension ImageDetailViewController {
    /// Fetches the Unsplash image and updates the image view.
    /// It uses the `fetchImage(for:completion:)` method of the `detailViewModel` to fetch the image.
    private func loadImage() {
        detailViewModel.fetchImage(for: imageRepresented.imageUrl) { [weak self] result in
            switch result {
            case .success(let image):
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.setImageViewAspectRatio(image: image)
                }
            case .failure(let error):
                // TODO: show an alert to the user
                print("Error fetching images: \(error)")
            }
        }
    }
    
    /// Fetches the profile image of the Unsplash image's user and updates the profile image view.
    /// It uses the `fetchImage(for:completion:)` method of the `detailViewModel` to fetch the profile image.
    private func loadProfileImage() {
        guard let url = imageRepresented.profileImageUrl else {
            self.profileImageView.image = UIImage(systemName: "person.circle")
            return
        }
        detailViewModel.fetchImage(for: url) { [weak self] result in
            switch result {
            case .success(let image):
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            case .failure( _):
                // TODO: show an alert to the user
                self?.profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
    }
}


// MARK: - UI Setup
extension ImageDetailViewController {
    /// It configures the scroll view, image view, username label, profile image view, social media label, and description label.
    private func setupUI() {
        view.backgroundColor = .white
        
        configureScrollView()
        configureImageView()
        configureUsernameLabel()
        configureProfileImageView()
        configureSocialMediaLabel()
        configureDescriptionLabel()
    }
    
    private func configureScrollView() {
        // Add the scroll view to the view
        view.addSubview(scrollView)
        
        // Add the image view, username label, and description label to the scroll view
        scrollView.addSubview(imageView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(socialMediaLabel)
        
        // Set up constraints for the scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func configureUsernameLabel() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            usernameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureProfileImageView() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureSocialMediaLabel() {
        NSLayoutConstraint.activate([
            socialMediaLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            socialMediaLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
        ])
    }
    
    private func configureDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setImageViewAspectRatio(image: UIImage) {
        // Remove any existing height constraints for imageView, since we're about to active a .height constraint based on aspectRatio
        imageView.constraints.forEach {
            if $0.firstAttribute == .height && $0.secondItem === imageView && $0.secondAttribute == .width {
                imageView.removeConstraint($0)
            }
        }
        
        // Calculate the aspect ratio of the image
        let aspectRatio = image.size.height / image.size.width
        
        // Set the height constraint based on the aspect ratio
        let constraint = NSLayoutConstraint(item: imageView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: imageView,
                                            attribute: .width,
                                            multiplier: aspectRatio,
                                            constant: 0)
        NSLayoutConstraint.activate([constraint])
    }
}
