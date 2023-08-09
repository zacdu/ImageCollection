//
//  ImageCollectionViewCell.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import UIKit

/// `ImageCollectionViewCell` is a subclass of `UICollectionViewCell` that displays an image.
///
/// This class provides a custom collection view cell that contains a single UIImageView. The image view is configured to scale its content to fill its bounds while maintaining the aspect ratio, and to clip any content that extends beyond its bounds. The image view is also set to fill the entire content view of the cell.
class ImageCollectionViewCell: UICollectionViewCell {
    
    /// A string identifier that can be used to dequeue reusable cells.
    static let reuseId = "ImageCell"
    
    /// This image view is configured to scale its content to fill its bounds while maintaining the aspect ratio, and to clip any content that extends beyond its bounds.
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// This method adds the image view to the content view and sets up constraints to make the image view fill the entire content view.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This method sets the image view's image to the specified image.
    ///
    /// - Parameter image: The image to display. If this is `nil`, the image view's image is set to `nil`.
    func configure(with image: UIImage?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}
