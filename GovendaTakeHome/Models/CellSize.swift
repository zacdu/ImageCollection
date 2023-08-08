//
//  CellSize.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import UIKit

/// `CellSize` is an enumeration that represents the possible sizes for a cell in a collection view.
///
/// Each case of the enumeration corresponds to a different size, and has an associated tuple value that represents the width and height of the cell as a fraction of the collection view's width and height.
///
/// For example, the `.small` case corresponds to a cell size that is 25% of the collection view's width and 25% of its height. The `.medium` case corresponds to a cell size that is 50% of the collection view's width and 50% of its height. The `.large` case corresponds to a cell size that is 100% of the collection view's width and 100% of its height.
enum CellSize {
    /// Represents a cell size that is 25% of the collection view's width and 25% of its height.
    case small
    /// Represents a cell size that is 50% of the collection view's width and 50% of its height.
    case medium
    /// Represents a cell size that is 100% of the collection view's width and 100% of its height.
    case large
    
    /// Returns the dimensions of the cell size as a tuple, where the first value is the width and the second value is the height. Both values are represented as a fraction of the collection view's width and height.
    var dimensions: (width: CGFloat, height: CGFloat) {
        switch self {
        case .small:
            return (0.25, 0.25) // 25% of the collectionView's width and height
        case .medium:
            return (0.5, 0.5)   // 50% of the collectionView's width and height
        case .large:
            return (1.0, 1.0)   // 100% of the collectionView's width and 100% of its height
        }
    }
}

