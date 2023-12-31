//
//  ImageCollectionView.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import UIKit

/// `ImageCollectionView` is a helper class that implements the `UICollectionViewDataSource` and `UICollectionViewDelegate` protocols.
/// It manages the data source and delegate methods for a collection view that displays images.
class ImageCollectionView: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// An array of `UnsplashImage` objects representing the images to be displayed in the collection view.
    var images: [ImageRepresentable] = []
    
    /// A weak reference to the delegate of the `ImageCollectionView`. The delegate is responsible for fetching the images.
    weak var delegate: ImageCollectionViewDelegate?

    /// Returns the number of items in the given section of the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: An index number identifying a section in `collectionView`.
    /// - Returns: The number of items in `section`.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item.
    /// - Returns: A configured cell object. You must not return `nil` from this method.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let image = images[indexPath.row]
        
        // Set a placeholder image or clear the current image
        cell.configure(with: nil)
        
        delegate?.fetchImage(for: image.imageUrl) { result in
            switch result {
            case .success(let image):
                cell.configure(with: image)
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView, didSelectImageAt: indexPath)
    }
    
    /// Updates the images to be displayed in the collection view.
    /// - Parameter newImages: An array of `UnsplashImage` objects representing the new images.
    func updateImages(_ newImages: [ImageRepresentable]) {
        self.images = newImages
    }
}









