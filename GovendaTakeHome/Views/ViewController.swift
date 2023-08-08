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
}

/// `ViewController` is responsible for displaying a collection of images fetched from the Unsplash API.
/// This class uses a ImageCollectionViewModel to fetch and manage the images, a CellSizeViewModel to manage the cell sizes, and a SegmentControlViewModel to handle changes in the segmented control.
class ViewController: UIViewController, ImageCollectionViewDelegate {
    
    // MARK: - Properties
    
    /// The view model responsible for fetching and managing the images.
    var imageViewModel: ImageCollectionViewModel
    
    /// The view model responsible for managing the cell sizes.
    var cellSizeViewModel = CellSizeViewModel()

    /// The segmented control for selecting the cell size.
    var segmentedControl: UISegmentedControl!
    
    /// The stack view containing the search text field and segmented control.
    var stackView: UIStackView!
    
    /// The collection view for displaying images.
    var collectionView: UICollectionView!
    
    /// The custom collection view for managing image data and interactions.
    /// responsible for handling the data source and delegate methods of the `collectionView`. It fetches and updates images from the Unsplash API, and handles user interactions with the collection view cells.
    var imageCollectionView: ImageCollectionView!

    
    /// Padding constant for layout.
    let padding: CGFloat = 20
    
    /// Height constant for the search text field.
    let textFieldHeight: CGFloat = 40
    
    init(service: UnsplashService) {
        self.imageViewModel = ImageCollectionViewModel(service: service)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        do {
            let service = try UnsplashService(apiKey: "O7E-kFrmIbkd-NWHkLxmSSmijJ-JzwGcOHltef0MSH0")
            self.imageViewModel = ImageCollectionViewModel(service: service)
            super.init(coder: coder)
        } catch {
            fatalError("Failed to create UnsplashService: \(error)")
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()       // Configure Search Bar, Segment Control, and CollectonView
        bindViewModel() // Load ViewModel, making initial network call
    }
    
    // MARK: - UI Setup
    
    /// Sets up the main UI components of the view.
    func setupUI() {
        configureStackView()
        configureCollectionView()
        
        imageCollectionView = ImageCollectionView()
        imageCollectionView.delegate = self
        collectionView.dataSource = imageCollectionView
        collectionView.delegate = imageCollectionView
    }
    
    /// Sets up the [SearchBar, SegmentControl] stack view and its child components.
    func configureStackView() {
        let searchTextField = ViewControllerUI.createSearchTextField()
        searchTextField.delegate = self
        
        segmentedControl = ViewControllerUI.createSegmentedControl()
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        
        stackView = UIStackView(arrangedSubviews: [searchTextField, segmentedControl])
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
    }
    
    /// Configures the collection view and its layout.
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.createLayout())
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
    }
    
    /// Binds the view model and calls initial `viewModel.fetchImages` to load default collection.
    func bindViewModel() {
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
    
    /// Fetches an image for the given URL, satisfying the `ImageCollectionViewDelegate` protocol
    /// This method uses the ImageCollectionViewModel to fetch the image. Once the image is fetched, it calls the provided completion handler.
    /// - Parameters:
    ///   - url: The URL of the image to fetch.
    ///   - completion: A closure to be executed once the fetch is complete. This closure takes a single argument: a Result containing the fetched UIImage on success, or an Error on failure.
    func fetchImage(for url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        imageViewModel.fetchImage(for: url, completion: completion)
    }
    
    /// Updates the collection view's images with the latest data from the ViewModel.
    /// This method should be called whenever the data in the ViewModel changes.
    func updateCollectionViewImages(_ images: [UnsplashImage]) {
        imageCollectionView.updateImages(images)
        collectionView.reloadData()
    }
    
    /// Handles changes in the segmented control.
    @objc func handleSegmentChange() {
        cellSizeViewModel.handleCellSizeChange(segmentIndex: segmentedControl.selectedSegmentIndex)
        collectionView.setCollectionViewLayout(CollectionViewLayoutFactory.createLayout(with: cellSizeViewModel.currentCellSize), animated: true)
        collectionView.reloadData()
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


