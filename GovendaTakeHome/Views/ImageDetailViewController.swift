//
//  ImageDetailViewController.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

/// A view controller that displays detailed information about an Unsplash image.
class ImageDetailViewController: UIViewController {

    // MARK: - UI Elements

    /// The scroll view that contains the other UI elements.
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// The image view that displays the Unsplash image.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// The label that displays the description of the Unsplash image.
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The label that displays the username of the Unsplash image's user.
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The image view that displays the profile image of the Unsplash image's user.
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// The label that displays the social media handle of the Unsplash image's user.
    private let socialMediaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties

    /// The Unsplash image to display.
    private var unsplashImage: UnsplashImage
    
    /// The view model that fetches images.
    private var detailViewModel: ImageDetailViewModel
    
    // MARK: - Initializer

    /// Creates a new image detail view controller for the specified Unsplash image.
    ///
    /// - Parameters:
    ///   - unsplashImage: The Unsplash image to display.
    ///   - service: The service to use to fetch images.
    init(unsplashImage: UnsplashImage, service: UnsplashService) {
        self.unsplashImage = unsplashImage
        self.detailViewModel = ImageDetailViewModel(service: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the UI
        setupUI()
        
        // Set the image and username
        fetchImage()
        fetchProfileImage()
        usernameLabel.text = unsplashImage.user?.name ?? "Unknown"
        descriptionLabel.text = unsplashImage.description ?? "No description"
        socialMediaLabel.text = "@\(unsplashImage.user?.username ?? "")"
    }
    
    // MARK: - UI Setup

    /// Sets up the user interface.
    private func setupUI() {
        // Set the background color
        view.backgroundColor = .white
        
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
        
        // Set up constraints for the image view, username label, and description label
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            profileImageView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            socialMediaLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            socialMediaLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Image Fetching

    /// Fetches the Unsplash image and updates the image view.
    private func fetchImage() {
        detailViewModel.fetchImage(for: unsplashImage.urls.regular) { [weak self] result in
            switch result {
            case .success(let image):
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            case .failure(let error):
                // TODO: show an alert to the user
                print("Error fetching images: \(error)")
            }
        }
    }
    
    /// Fetches the profile image of the Unsplash image's user and updates the profile image view.
    private func fetchProfileImage() {
        guard let url = unsplashImage.user?.profileImage?.small else { return }
        detailViewModel.fetchImage(for: url) { [weak self] result in
            switch result {
            case .success(let image):
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            case .failure(let error):
                // TODO: show an alert to the user
                print("Error fetching profile image: \(error)")
            }
        }
    }
}


