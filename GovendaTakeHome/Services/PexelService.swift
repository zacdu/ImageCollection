//
//  PexelService.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

/// `PexelService` is a class that conforms to the `NetworkImageService` protocol and provides methods to fetch images from the Pexels API.
class PexelService: NetworkImageService {

    /// The API key used for authenticating requests to the Pexels API.
    let apiKey: String
    /// The base URL used for making requests to the Pexels API.
    let baseUrl: String = "https://api.pexels.com/v1/search"
    var authHeaderField: String? = "Authorization"

    
    /// Initializes a new `PexelService` instance with the given API key.
    ///
    /// - Parameter apiKey: The API key used for authenticating requests to the Pexels API.
    /// - Throws: An `ImageServiceError.invalidAPIKey` error if the provided API key is empty.
    init(apiKey: String) throws {
        guard !apiKey.isEmpty else { throw NetworkImageServiceError.invalidAPIKey }
        self.apiKey = apiKey
    }
    
    /// Fetches images from the Pexels API based on the given query.
    ///
    /// - Parameter query: The search query used to find images.
    /// - Returns: An array of objects conforming to `ImageRepresentable`, representing the images found.
    /// - Throws: A `URLError.userAuthenticationRequired` error if the API key is empty.
    ///           A `URLError.badURL` error if the URL is malformed.
    ///           Any other errors that may occur during the network request.
    func fetchImages(query: String) async throws -> [ImageRepresentable] {
        guard !apiKey.isEmpty else { throw URLError(.userAuthenticationRequired) }
        guard var url = URL(string: baseUrl) else { throw URLError(.badURL) }
        let items: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        url.append(queryItems: items)
        
        var request = URLRequest(url: url)
        if let authHeader = authHeaderField {
            request.setValue(apiKey, forHTTPHeaderField: authHeader)
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let searchResult = try decoder.decode(PexelsResponse.self, from: data)
        return searchResult.photos
    }
    
    /// Fetches an image from the Pexels API based on the given URL.
    ///
    /// - Parameter url: The URL of the image to fetch.
    /// - Returns: A `UIImage` object representing the fetched image.
    /// - Throws: An `ImageServiceError.invalidAPIKey` error if the API key is empty.
    ///           Any other errors that may occur during the network request.
    func fetchImage(url: URL) async throws -> UIImage {
        guard !apiKey.isEmpty else { throw NetworkImageServiceError.invalidAPIKey }
        var request = URLRequest(url: url)
        if let authHeader = authHeaderField {
            request.setValue(apiKey, forHTTPHeaderField: authHeader)
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let image = UIImage(data: data) else { return UIImage(systemName: "photo") ?? UIImage() }
        return image
    }
}

