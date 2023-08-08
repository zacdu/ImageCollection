//
//  ImageService.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import UIKit

protocol ImageService {
    func fetchImages(query: String) async throws -> [UnsplashImage]
    func fetchImage(url: URL) async throws -> UIImage
}
