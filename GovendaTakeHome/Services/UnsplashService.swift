//
//  UnsplashService.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import UIKit

/// `UnsplashService` is a class that provides methods for fetching images and image data from the Unsplash API.
///
/// This class uses the URLSession API for networking and the JSONDecoder for decoding the JSON response from the API into Swift data types.
///
/// The Unsplash API requires an API key for authorization, which is included in the headers of the HTTP requests made by this class.
class UnsplashService: ImageService {
    /// The API key for the Unsplash API.
    let apiKey: String
    private let authHeaderField = "Authorization"
    private let authHeaderValue = "Client-ID"
    
    init(apiKey: String) throws {
        guard !apiKey.isEmpty else { throw ImageServiceError.invalidAPIKey }
        self.apiKey = apiKey
    }

    /// Fetches an image from the Unsplash API.
    ///
    /// This method makes an asynchronous HTTP request to the Unsplash API to fetch an image. The image is returned as a UIImage.
    ///
    /// - Parameter url: The URL of the image to fetch.
    /// - Returns: A UIImage of the fetched image.
    /// - Throws: An error if there was a problem fetching the image.
    func fetchImage(url: URL) async throws -> UIImage {
        guard !apiKey.isEmpty else { throw ImageServiceError.invalidAPIKey }

        var request = URLRequest(url: url)
        request.setValue(authHeaderValue + " " + apiKey, forHTTPHeaderField: authHeaderField)
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let image = UIImage(data: data) else { return UIImage(systemName: "photo") ?? UIImage() }
        return image
    }
    
    /// Fetches a list of images from the Unsplash API based on a search query.
    ///
    /// This method makes an asynchronous HTTP request to the Unsplash API to fetch a list of images based on a search query. The images are returned as an array of `UnsplashImage` objects.
    ///
    /// - Parameter query: The search query to use when fetching the images.
    /// - Returns: An array of `UnsplashImage` objects representing the fetched images.
    /// - Throws: An error if there was a problem fetching the images.
    func fetchImages(query: String) async throws -> [UnsplashImage] {
        guard !apiKey.isEmpty else { throw URLError(.userAuthenticationRequired) }
        let urlString = "https://api.unsplash.com/search/photos"
        guard var url = URL(string: urlString) else { throw URLError(.badURL) }
        let items: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        url.append(queryItems: items)
        
        var request = URLRequest(url: url)
        request.setValue(authHeaderValue + " " + apiKey, forHTTPHeaderField: authHeaderField)
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let searchResult = try JSONDecoder().decode(UnsplashSearchResult.self, from: data)
        return searchResult.results
    }
}

