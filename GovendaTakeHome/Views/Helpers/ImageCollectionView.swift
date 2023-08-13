//
//  ImageCollectionView.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import UIKit

/// `ImageCollectionView` is a helper class that manages the data source and delegate methods
/// for a collection view that displays images. It also includes caching to efficiently handle
/// image loading.
class ImageCollectionView: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// An array of objects conforming to `ImageRepresentable` that represents the images to be displayed in the collection view.
    var images: [ImageRepresentable] = []
    
    /// A weak reference to the delegate of the `ImageCollectionView`. The delegate is responsible for fetching the images.
    weak var delegate: ImageCollectionViewDelegate?
    
    /// A cache for storing downloaded images, keyed by their URL as a string.
    /// This cache helps in reusing downloaded images and reduces redundant network calls.
    let imageCache = NSCache<NSString, UIImage>()

    /// Returns the number of items in the given section of the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: An index number identifying a section in `collectionView`.
    /// - Returns: The number of items in `section`.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    /// Asks the data source for the cell that corresponds to the specified item in the collection view.
    /// It also handles image caching and asynchronous loading.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item.
    /// - Returns: A configured cell object with the appropriate image.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let image = images[indexPath.row]
        
        // Check if the image is already cached, and use it if available
        if let cachedImage = imageCache.object(forKey: image.imageUrl.absoluteString as NSString) {
            cell.configure(with: cachedImage)
            return cell
        }
        
        // Set a placeholder image or clear the current image while the actual image is being fetched
        cell.configure(with: nil)
        
        // Fetch the image through the delegate, cache it, and update the cell
        delegate?.fetchImage(for: image.imageUrl) { [weak self] result in
            switch result {
            case .success(let resultImage):
                // Cache the downloaded image
                self?.imageCache.setObject(resultImage, forKey: image.imageUrl.absoluteString as NSString)
                // Configure the cell with the downloaded image
                cell.configure(with: resultImage)
            case .failure(let error):
                print("Error loading image: \(error)") // Consider handling this error more gracefully
            }
        }
        return cell
    }
    
    /// Handles the selection of an item in the collection view and forwards the event to the delegate.
    /// - Parameters:
    ///   - collectionView: The collection view where the selection occurred.
    ///   - indexPath: The index path of the selected item.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView, didSelectImageAt: indexPath)
    }
    
    /// Updates the images to be displayed in the collection view.
    /// - Parameter newImages: An array of objects conforming to `ImageRepresentable` representing the new images.
    func updateImages(_ newImages: [ImageRepresentable]) {
        self.images = newImages
    }
}
