//
//  ImageCollectionViewModel.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

/// `ImageCollectionViewModel` is responsible for fetching images from the Unsplash API.
///
/// This class uses the `NetworkImageService` to fetch images based on a search query and to fetch individual images based on their URL. The fetched images are returned to the caller through completion handlers.
class ImageCollectionViewModel {
    
    /// The service object that fetches images from the Unsplash API.
    let service: NetworkImageService
    private static let defaultQuery = "Nature"
    
    init(service: NetworkImageService) {
        self.service = service
    }
    
    /// Fetches a list of images from the Unsplash API based on a search query.
    ///
    /// This method uses the `NetworkImageService` to fetch images based on the specified search query. Once the images are fetched, it calls the provided completion handler.
    ///
    /// - Parameters:
    ///   - query: The search query to use when fetching images.
    ///   - completion: A closure to be executed once the fetch is complete. This closure takes a single argument: a Result containing an array of `UnsplashImage` objects on success, or an Error on failure.
    func fetchImages(for query: String = defaultQuery, completion: @escaping (Result<[ImageRepresentable], Error>) -> Void) {
        Task {
            do {
                let images = try await service.fetchImages(query: query)
                completion(.success(images))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches an image from the Unsplash API based on its URL.
    ///
    /// This method uses the `NetworkImageService` to fetch an image based on the specified URL. Once the image is fetched, it calls the provided completion handler.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to fetch.
    ///   - completion: A closure to be executed once the fetch is complete. This closure takes a single argument: a Result containing the fetched UIImage on success, or an Error on failure.
    func fetchImage(for url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        Task {
            do {
                let image = try await service.fetchImage(url: url)
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
