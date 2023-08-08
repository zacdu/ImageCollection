//
//  ImageDetailViewModel.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

class ImageDetailViewModel {
    
    /// The service object that fetches images from the Unsplash API.
    let service: UnsplashService
    
    init(service: UnsplashService) {
        self.service = service
    }
    
    /// Fetches an image from the Unsplash API based on its URL.
    ///
    /// This method uses the `UnsplashService` to fetch an image based on the specified URL. Once the image is fetched, it calls the provided completion handler.
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
