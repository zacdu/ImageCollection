//
//  ServiceError.swift
//  GovendaTakeHome
//
//  Created by Zachary Duvall on 8/8/23.
//

import Foundation

enum NetworkImageServiceError: Error {
    case invalidAPIKey
    case invalidProfileURL
}
