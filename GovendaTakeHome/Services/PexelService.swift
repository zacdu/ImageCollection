//
//  PexelService.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

class PexelService: ImageService {
    let apiKey: String
    
    init(apiKey: String) throws {
        guard !apiKey.isEmpty else { throw ImageServiceError.invalidAPIKey }
        self.apiKey = apiKey
    }
    
    func fetchImages(query: String) async throws -> [ImageRepresentable] {
        guard !apiKey.isEmpty else { throw URLError(.userAuthenticationRequired) }
        let urlString = "https://api.pexels.com/v1/search"
        guard var url = URL(string: urlString) else { throw URLError(.badURL) }
        let items: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        url.append(queryItems: items)
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let searchResult = try decoder.decode(PexelsResponse.self, from: data)
        return searchResult.photos
    }
    
    func fetchImage(url: URL) async throws -> UIImage {
        guard !apiKey.isEmpty else { throw ImageServiceError.invalidAPIKey }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let image = UIImage(data: data) else { return UIImage(systemName: "photo") ?? UIImage() }
        return image
    }
}
