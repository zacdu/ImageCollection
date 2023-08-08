//
//  GovendaTakeHomeTests.swift
//  GovendaTakeHomeTests
//
//  Created by Zachary Duvall on 8/7/23.
//

import XCTest
@testable import GovendaTakeHome


final class ImageCollectionViewModelTests: XCTestCase {
    var viewModel: ImageCollectionViewModel!
    let validAPIKey = "O7E-kFrmIbkd-NWHkLxmSSmijJ-JzwGcOHltef0MSH0"
    let invalidAPIKey = ""

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchImagesWithValidAPIKey() throws {
        do {
            let service = try UnsplashService(apiKey: validAPIKey)
            viewModel = ImageCollectionViewModel(service: service)
            let expectation = XCTestExpectation(description: "Fetch images from Unsplash API with valid API key")

            viewModel.fetchImages(for: "Nature") { result in
                switch result {
                case .success(let images):
                    XCTAssertFalse(images.isEmpty, "No images were fetched.")
                case .failure(let error):
                    XCTFail("Failed to fetch images: \(error)")
                }
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchImagesWithInvalidAPIKey() throws {
        do {
            let service = try UnsplashService(apiKey: invalidAPIKey)
            viewModel = ImageCollectionViewModel(service: service)
            let expectation = XCTestExpectation(description: "Fetch images from Unsplash API with invalid API key")

            viewModel.fetchImages(for: "Nature") { result in
                switch result {
                case .success(_):
                    XCTFail("Images were fetched with an invalid API key")
                case .failure(let error):
                    XCTAssert(error is UnsplashServiceError, "Unexpected error: \(error)")
                    expectation.fulfill()
                }
            }

            wait(for: [expectation], timeout: 10.0)
        } catch UnsplashServiceError.invalidAPIKey {
            // Expected error, test passed
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchImageWithValidAPIKey() throws {
        do {
            let service = try UnsplashService(apiKey: validAPIKey)
            viewModel = ImageCollectionViewModel(service: service)
            let expectation = XCTestExpectation(description: "Fetch image from Unsplash API with valid API key")
            let validURL = URL(string: "https://images.unsplash.com/photo-1423784346385-c1d4dac9893a?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=d60d527cb347746ab3abf5fccecf0271")!

            viewModel.fetchImage(for: validURL) { result in
                switch result {
                case .success(let image):
                    XCTAssertNotNil(image, "No image was fetched.")
                case .failure(let error):
                    XCTFail("Failed to fetch image: \(error)")
                }
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchImageWithInvalidAPIKey() throws {
        do {
            let service = try UnsplashService(apiKey: invalidAPIKey)
            viewModel = ImageCollectionViewModel(service: service)
            let expectation = XCTestExpectation(description: "Fetch image from Unsplash API with invalid API key")
            let validURL = URL(string: "https://images.unsplash.com/photo-1423784346385-c1d4dac9893a?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=d60d527cb347746ab3abf5fccecf0271")!

            viewModel.fetchImage(for: validURL) { result in
                switch result {
                case .success(_):
                    XCTFail("Image was fetched with an invalid API key")
                case .failure(let error):
                    XCTAssert(error is UnsplashServiceError, "Unexpected error: \(error)")
                    expectation.fulfill()
                }
            }

            wait(for: [expectation], timeout: 10.0)
        } catch UnsplashServiceError.invalidAPIKey {
            // Expected error, test passed
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

