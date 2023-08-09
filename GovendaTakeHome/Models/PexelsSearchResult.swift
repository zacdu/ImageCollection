//
//  PexelsSearchResult.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import Foundation

/// `PexelsResponse` represents the top-level response from the Pexels API.
struct PexelsResponse: Codable {
    /// The total number of results available for the query.
    let totalResults: Int?
    /// The current page number in the paginated response.
    let page: Int?
    /// The number of results per page.
    let perPage: Int?
    /// An array of `Photo` objects, representing the photos returned by the query.
    let photos: [Photo]
    /// The URL for the next page in the paginated response.
    let nextPage: String?
}


/// `Photo` represents a photo returned by the Pexels API.
struct Photo: Codable {
    /// The unique identifier for the photo.
    let id: Int
    /// The width of the photo in pixels.
    let width: Int
    /// The height of the photo in pixels.
    let height: Int
    /// The URL of the photo on the Pexels website.
    let url: String
    /// The name of the photographer.
    let photographer: String
    /// The URL of the photographer's profile on the Pexels website.
    let photographerUrl: String
    /// The unique identifier for the photographer.
    let photographerId: Int
    /// The average color of the photo, represented as a hexadecimal color code.
    let avgColor: String?
    /// A `Source` object, containing various versions of the photo.
    let src: Source
    /// A Boolean value indicating whether the photo has been liked by the user.
    let liked: Bool?
    /// A description of the photo.
    let alt: String
}


/// Conformance to ImageRepresentable
extension Photo: ImageRepresentable {
    var imageUrl: URL { return URL(string: src.medium)! }
    
    var profileImageUrl: URL? { return nil }
    
    var username: String? { return photographer }
    
    var description: String? { return alt }
    
    var socialMedia: String? { photographerUrl }
}


/// `Source` represents various versions of a photo, each with a different size or aspect ratio.
struct Source: Codable {
    /// The URL of the original, full-resolution photo.
    let original: String
    /// The URL of a large, 2x resolution version of the photo.
    let large2x: String
    /// The URL of a large version of the photo.
    let large: String
    /// The URL of a medium-sized version of the photo.
    let medium: String
    /// The URL of a small version of the photo.
    let small: String
    /// The URL of a version of the photo cropped to a portrait aspect ratio.
    let portrait: String
    /// The URL of a version of the photo cropped to a landscape aspect ratio.
    let landscape: String
    /// The URL of a tiny version of the photo.
    let tiny: String
}
