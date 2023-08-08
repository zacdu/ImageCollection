//
//  ViewControllerUI.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import UIKit

/// `ViewControllerUI` is a class that provides static methods for creating reusable UI components.
///
/// This class currently provides methods for creating a search text field and a segmented control. These methods return fully configured instances of the respective UI components, ready to be added to a view.
class ViewControllerUI {
    
    /// Creates and returns a UITextField configured for searching.
    ///
    /// This method creates a UITextField, sets its placeholder text to "Search for images...", its border style to roundedRect, and its return key type to search.
    ///
    /// - Returns: A UITextField configured for searching.
    static func createSearchTextField() -> UITextField {
        let searchTextField = UITextField()
        searchTextField.placeholder = "Search for images..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.returnKeyType = .search
        return searchTextField
    }
    
    /// Creates and returns a UISegmentedControl with three segments: "Small", "Medium", and "Large".
    ///
    /// This method creates a UISegmentedControl with three segments, sets the selected segment index to 1 (corresponding to "Medium"), and returns the segmented control.
    ///
    /// - Returns: A UISegmentedControl with three segments: "Small", "Medium", and "Large".
    static func createSegmentedControl() -> UISegmentedControl {
        let items = ["Small", "Medium", "Large"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 1 // Default to "Medium"
        return segmentedControl
    }
}




