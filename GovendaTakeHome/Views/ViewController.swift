//
//  ViewController.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import UIKit

/// A delegate protocol for the `ImageCollectionView`.
/// This protocol defines a method for fetching an image for a given URL.
protocol ImageCollectionViewDelegate: AnyObject {
    /// Fetches an image for the given URL.
    /// - Parameters:
    ///   - url: The URL of the image to fetch.
    ///   - completion: A closure to be executed once the fetch is complete. This closure takes a single argument: a Result containing the fetched UIImage on success, or an Error on failure.
    func fetchImage(for url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
    
    func collectionView(_ collectionView: UICollectionView, didSelectImageAt indexPath: IndexPath)
}

/// `ViewController` is responsible for displaying a collection of images fetched from the Unsplash API.
/// This class uses a ImageCollectionViewModel to fetch and manage the images, a CellSizeViewModel to manage the cell sizes, and a SegmentControlViewModel to handle changes in the segmented control.
class ViewController: UIViewController {
    
    // MARK: - Properties
    /// The view model responsible for fetching and managing the images.
    let imageViewModel: ImageCollectionViewModel
    
    /// The view model responsible for managing the cell sizes.
    let cellSizeViewModel = CellSizeViewModel()
    
    // MARK: - UI Elements

    /// The segmented control for selecting the cell size.
    /// It allows the user to choose between different cell sizes for the collection view.
    let segmentedControl: UISegmentedControl
    
    /// The search field for querying photos.
    /// It allows the user to enter a search term to query images from the Unsplash API.
    let searchTextField: UITextField
    
    /// The stack view containing the search text field and segmented control.
    /// It organizes the search field and segmented control in a vertical stack.
    let stackView: UIStackView
    
    /// The collection view for displaying images.
    /// It displays the images fetched from the Unsplash API in a grid layout.
    let collectionView: UICollectionView
    
    /// The custom collection view for managing image data and interactions.
    /// It is responsible for handling the data source and delegate methods of the `collectionView`. It fetches and updates images from the Unsplash API, and handles user interactions with the collection view cells.
    let imageCollectionView: ImageCollectionView
    
    /// Padding constant for layout.
    /// It is used to provide consistent spacing around the UI elements.
    let padding: CGFloat = 20
    
    /// Height constant for the search text field.
    /// It defines the height of the search text field in the stack view.
    let textFieldHeight: CGFloat = 40
    
    /// Initializes a new instance of the ViewController with the specified ImageService.
    /// - Parameter service: The ImageService to use for fetching images.
    init(service: ImageService) {
        // We inject the Service to allow for hotswapping other services that perform  Query -> Images work.
        self.imageViewModel = ImageCollectionViewModel(service: service)
        // These are the UI components internal to the ViewController
        self.imageCollectionView = ImageCollectionView()
        self.segmentedControl = ViewControllerUI.createSegmentedControl()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.createLayout())
        self.searchTextField = ViewControllerUI.createSearchTextField()
        self.stackView = UIStackView(arrangedSubviews: [searchTextField, segmentedControl])
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Required initializer for the ViewController.
    /// It creates a new instance of the ImageService and initializes the view model with it.
    required init?(coder: NSCoder) {
        do {
            let unsplashService = try UnsplashService(apiKey: "O7E-kFrmIbkd-NWHkLxmSSmijJ-JzwGcOHltef0MSH0")
            let pexelService = try PexelService(apiKey: "DMG4hXCfWTDXWsjRezp4kIxlQuF8l0onFbNv3IzvXS58WtzQQ1QZWMqb")
            
            self.imageViewModel = ImageCollectionViewModel(service: unsplashService)
            self.imageCollectionView = ImageCollectionView()
            self.segmentedControl = ViewControllerUI.createSegmentedControl()
            self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.createLayout())
            self.searchTextField = ViewControllerUI.createSearchTextField()
            self.stackView = UIStackView(arrangedSubviews: [searchTextField, segmentedControl])
            super.init(coder: coder)
        } catch {
            fatalError("Failed to create UnsplashService: \(error)")
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()       // Configure Search Bar, Segment Control, and CollectonView
        fetchInitialImages() // Load ViewModel, making initial network call
    }

}

// MARK: - UI Setup
extension ViewController {
    /// Updates the collection view's images with the latest data from the ViewModel.
    /// This method should be called whenever the data in the ViewModel changes.
    func updateCollectionViewImages(_ images: [ImageRepresentable]) {
        imageCollectionView.updateImages(images)
        collectionView.reloadData()
    }
    
    /// Makes initial call for default image collection
    func fetchInitialImages() {
        imageViewModel.fetchImages() { [weak self] result in
            switch result {
            case .success(let images):
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self?.updateCollectionViewImages(images)
                }
            case .failure(let error):
                // TODO: show an alert to the user
                print("Error fetching images: \(error)")
            }
        }
    }
    
    /// Sets up the main UI components of the view.
    func setupUI() {
        configureStackView()
        configureCollectionView()
    }
    
    /// Sets up the [SearchBar, SegmentControl] stack view and its child components.
    func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])

        configureStackViewDelegation()
    }
    
    /// Configures the collection view and its layout.
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        configureCollectionViewDelegation()
    }
    
    /// Configures the delegation for the stack view components.
    /// It sets the delegate for the search text field and adds a target-action for the segmented control.
    func configureStackViewDelegation() {
        searchTextField.delegate = self
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
    }
    
    /// Configures the delegation for the collection view.
    /// It sets the delegate and data source for the collection view to the `imageCollectionView`.
    func configureCollectionViewDelegation() {
        imageCollectionView.delegate = self
        collectionView.dataSource = imageCollectionView
        collectionView.delegate = imageCollectionView
    }
    
    /// Handles changes in the segmented control.
    @objc func handleSegmentChange() {
        cellSizeViewModel.handleCellSizeChange(segmentIndex: segmentedControl.selectedSegmentIndex)
        collectionView.setCollectionViewLayout(CollectionViewLayoutFactory.createLayout(with: cellSizeViewModel.currentCellSize), animated: true)
        collectionView.reloadData()
    }
}


// MARK: - ImageCollectionViewDelegate
extension ViewController: ImageCollectionViewDelegate {
    /// Fetches an image for the given URL, satisfying the `ImageCollectionViewDelegate` protocol
    /// This method uses the ImageCollectionViewModel to fetch the image. Once the image is fetched, it calls the provided completion handler.
    /// - Parameters:
    ///   - url: The URL of the image to fetch.
    ///   - completion: A closure to be executed once the fetch is complete. This closure takes a single argument: a Result containing the fetched UIImage on success, or an Error on failure.
    func fetchImage(for url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        imageViewModel.fetchImage(for: url, completion: completion)
    }
}


// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = textField.text, !query.isEmpty {
            imageViewModel.fetchImages(for: query) { [weak self] result in
                switch result {
                case .success(let images):
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self?.updateCollectionViewImages(images)
                    }
                case .failure(let error):
                    // Handle the error, e.g., show an alert to the user
                    print("Error fetching images: \(error)")
                    // Optionally, you can add code here to display an alert to the user
                }
            }
        }
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - UICollectionViewDelegate
extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectImageAt indexPath: IndexPath) {
        // Get the selected image
        let selectedImage = imageCollectionView.images[indexPath.item]
        
        do {
            // Create an instance of ImageService
            let unsplashService = try UnsplashService(apiKey: "O7E-kFrmIbkd-NWHkLxmSSmijJ-JzwGcOHltef0MSH0")
            let pexelService = try PexelService(apiKey: "DMG4hXCfWTDXWsjRezp4kIxlQuF8l0onFbNv3IzvXS58WtzQQ1QZWMqb")

            // Create an instance of ImageDetailViewController
            let detailViewController = ImageDetailViewController(image: selectedImage, service: unsplashService)
            
            // Present the detail view controller modally
            present(detailViewController, animated: true, completion: nil)
        } catch {
            print("Failed to create UnsplashService: \(error)")
            // TODO: Show an alert to the user
        }
    }
}
