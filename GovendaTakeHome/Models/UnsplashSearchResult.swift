//
//  UnsplashSearchResult.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/7/23.
//

import Foundation

/// Represents root response object from `UnsplashService.fetchImages`
struct UnsplashSearchResult: Codable {
    let results: [UnsplashImage]
}

struct UnsplashImage: Codable {
    let id: String
    let title: String?
    let description: String?
    let urls: ImageURLs
}

struct ImageURLs: Codable {
    let thumb: URL
    let regular: URL
}
