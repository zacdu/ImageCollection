//
//  CellSizeViewModel.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

/// `CellSizeViewModel` is responsible for managing the current cell size in a collection view.
///
/// This class holds a `currentCellSize` property that represents the current cell size. It also provides a method to handle changes in cell size based on a segmented control's selected index.
class CellSizeViewModel {
    
    /// The current cell size. Defaults to `.medium`.
    var currentCellSize: CellSize = .medium
    
    /// Handles changes in cell size based on a segmented control's selected index.
    ///
    /// This method updates the `currentCellSize` property based on the selected index of a segmented control. The indices correspond to the following cell sizes:
    /// - 0: Small
    /// - 1: Medium
    /// - 2: Large
    ///
    /// - Parameter segmentIndex: The selected index of a segmented control.
    func handleCellSizeChange(segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            currentCellSize = .small
        case 1:
            currentCellSize = .medium
        case 2:
            currentCellSize = .large
        default:
            break
        }
    }
}

