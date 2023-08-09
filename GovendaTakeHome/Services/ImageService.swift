//
//  ImageService.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

/// `ImageService` protocol defines the methods required for fetching images.
/// It provides a generic interface for fetching images and image details, allowing different services to implement their own logic.
protocol ImageService {
    /// Fetches a collection of images based on a search query.
    /// - Parameter query: The search query used to fetch the images.
    /// - Returns: An array of objects conforming to `ImageRepresentable`, representing the fetched images.
    /// - Throws: An error if there was a problem fetching the images.
    func fetchImages(query: String) async throws -> [ImageRepresentable]

    /// Fetches a single image from a given URL.
    /// - Parameter url: The URL of the image to fetch.
    /// - Returns: A `UIImage` representing the fetched image.
    /// - Throws: An error if there was a problem fetching the image.
    func fetchImage(url: URL) async throws -> UIImage
}
