//
//  CollectionViewLayoutFactory.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import UIKit

/// `CollectionViewLayoutFactory` is a utility struct that provides a method to create a custom layout for a collection view.
///
/// The `createLayout(with:)` method creates a `UICollectionViewLayout` object representing the custom layout. It uses the dimensions of a `CellSize` object to determine the size of the cells in the layout.
///
/// - Parameter cellSize: A `CellSize` object representing the size of the cells in the layout. This parameter has a default value of `.medium`.
///
/// - Returns: A `UICollectionViewLayout` object representing the custom layout. The layout consists of a single section with a horizontal group of items. The items have a fractional width and height based on the dimensions of the `CellSize` object, and have content insets.
struct CollectionViewLayoutFactory {
    static func createLayout(with cellSize: CellSize = .medium) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(cellSize.dimensions.width), heightDimension: .fractionalWidth(cellSize.dimensions.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(cellSize.dimensions.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
