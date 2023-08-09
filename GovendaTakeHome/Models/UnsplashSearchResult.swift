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

// MARK: - UnsplashImage: ImageRepresentable
extension UnsplashImage: ImageRepresentable {
    var imageUrl: URL { return urls.regular }
    var profileImageUrl: URL? { return user?.profileImage?.medium }
    var username: String? { return user?.username }
    var socialMedia: String? {
        if let insta = user?.instagramUsername {
            return insta
        } else if let twitter = user?.twitterUsername {
            return twitter
        } else {
            return user?.instagramUsername
        }
    }
}

struct UnsplashImage: Codable {
    let id: String
    let createdAt: String?
    let width: Int?
    let height: Int?
    let color: String?
    let blurHash: String?
    let likes: Int?
    let likedByUser: Bool?
    let description: String?
    let user: User?
    let urls: ImageURLs
    let links: ImageLinks?
}

struct User: Codable {
    let id: String
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let instagramUsername: String?
    let twitterUsername: String?
    let portfolioUrl: String?
    let profileImage: ProfileImage?
    let links: UserLinks?
}

struct ProfileImage: Codable {
    let small: URL
    let medium: URL
    let large: URL
}

struct UserLinks: Codable {
    let selfLink: URL
    let html: URL
    let photos: URL
    let likes: URL

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case photos
        case likes
    }
}

struct ImageURLs: Codable {
    let thumb: URL
    let regular: URL
    let full: URL
    let raw: URL
    let small: URL
}

struct ImageLinks: Codable {
    let selfLink: URL
    let html: URL
    let download: URL

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case download
    }
}
