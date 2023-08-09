//
//  ImageRepresentable.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import Foundation

/// `ImageRepresentable` protocol defines the properties required to represent an image.
/// It provides a generic interface for representing images, allowing different services to include their own specific properties.
protocol ImageRepresentable {
    /// The URL of the image.
    var imageUrl: URL { get }

    /// The URL of the profile image associated with the image, if available.
    var profileImageUrl: URL? { get }

    /// The username of the user who uploaded the image, if available.
    var username: String? { get }

    /// A description of the image, if available.
    var description: String? { get }

    /// A link to the social media profile of the user who uploaded the image, if available.
    var socialMedia: String? { get }
}
