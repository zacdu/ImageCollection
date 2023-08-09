//
//  GovendaTakeHomeTests.swift
//  GovendaTakeHomeTests
//
//  Created by Zachary Duvall on 8/7/23.
//

import XCTest
@testable import GovendaTakeHome


final class UnsplashServiceViewModelTests: XCTestCase {
    
    /// The view model under test.
    var viewModel: ImageCollectionViewModel!
    
    /// A valid API key for the Unsplash API.
    let validAPIKey = "O7E-kFrmIbkd-NWHkLxmSSmijJ-JzwGcOHltef0MSH0"
    
    /// An invalid API key for the Unsplash API.
    let invalidAPIKey = ""
    
    /// A method called before each test in the test case. This method is where you put setup code.
    override func setUp() {
        super.setUp()
    }
    
    /// A method called after each test in the test case. This method is where you put teardown code.
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    /// Tests the `fetchImages` method of the `ImageCollectionViewModel` with a valid API key.
    ///
    /// This test expects the `fetchImages` method to successfully fetch images and fulfill the expectation.
    func testFetchImagesWithValidAPIKey() throws {
        // Create a UnsplashService with a valid API key and an ImageCollectionViewModel with this service.
        let service = try UnsplashService(apiKey: validAPIKey)
        viewModel = ImageCollectionViewModel(service: service)
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Fetch images from Unsplash API with valid API key")
        
        // Call the method under test.
        viewModel.fetchImages(for: "Nature") { result in
            switch result {
            case .success(let images):
                // If the fetch is successful, the images array should not be empty.
                XCTAssertFalse(images.isEmpty, "No images were fetched.")
            case .failure(let error):
                // If the fetch fails, the test fails.
                XCTFail("Failed to fetch images: \(error)")
            }
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
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
                    XCTAssert(error is NetworkImageServiceError, "Unexpected error: \(error)")
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 10.0)
        } catch NetworkImageServiceError.invalidAPIKey {
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
                    XCTAssert(error is NetworkImageServiceError, "Unexpected error: \(error)")
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 10.0)
        } catch NetworkImageServiceError.invalidAPIKey {
            // Expected error, test passed
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchImagesWithEmptySearchTerms() throws {
        let service = try UnsplashService(apiKey: validAPIKey)
        viewModel = ImageCollectionViewModel(service: service)
        
        let expectation = XCTestExpectation(description: "Fetch query for empty search terms")
        let term = ""
        
        viewModel.fetchImages(for: term) { result in
            switch result {
            case .success(let images):
                XCTAssert(images.isEmpty, "No images were fetched for term: \(term)")
            case .failure(let error):
                XCTFail("Failed to fetch images for term: \(term). Error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchImageWithValidURL() throws {
        let service = try UnsplashService(apiKey: validAPIKey)
        viewModel = ImageCollectionViewModel(service: service)
        
        let expectation = XCTestExpectation(description: "Fetch image for different URLs")
        
        let url = URL(string: "https://images.unsplash.com/photo-1423784346385-c1d4dac9893a?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=d60d527cb347746ab3abf5fccecf0271")!
        
        
        viewModel.fetchImage(for: url) { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image, "No image was fetched for URL: \(url)")
            case .failure(let error):
                XCTFail("Failed to fetch image for URL: \(url). Error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchImageWithInvalidURL() throws {
        let service = try UnsplashService(apiKey: validAPIKey)
        viewModel = ImageCollectionViewModel(service: service)
        
        let expectation = XCTestExpectation(description: "Fetch image for different URLs")
        
        let url = URL(string: "https://invalid-url")!
        
        viewModel.fetchImage(for: url) { result in
            switch result {
            case .success( _):
                XCTFail("Fetch image for invalid URL: \(url)")
            case .failure(let error):
                XCTAssertNotNil(error, "No image was fetched for URL: \(url)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}



final class PexelServiceViewModelTests: XCTestCase {
    
    /// The view model under test.
    var viewModel: ImageCollectionViewModel!
    
    /// A valid API key for the Unsplash API.
    let validAPIKey = "DMG4hXCfWTDXWsjRezp4kIxlQuF8l0onFbNv3IzvXS58WtzQQ1QZWMqb"
    
    /// An invalid API key for the Unsplash API.
    let invalidAPIKey = ""
    
    /// A method called before each test in the test case. This method is where you put setup code.
    override func setUp() {
        super.setUp()
    }
    
    /// A method called after each test in the test case. This method is where you put teardown code.
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    /// Tests the `fetchImages` method of the `ImageCollectionViewModel` with a valid API key.
    ///
    /// This test expects the `fetchImages` method to successfully fetch images and fulfill the expectation.
    func testFetchImagesWithValidAPIKey() throws {
        // Create a UnsplashService with a valid API key and an ImageCollectionViewModel with this service.
        let service = try PexelService(apiKey: validAPIKey)
        viewModel = ImageCollectionViewModel(service: service)
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Fetch images from Unsplash API with valid API key")
        
        // Call the method under test.
        viewModel.fetchImages(for: "Nature") { result in
            switch result {
            case .success(let images):
                // If the fetch is successful, the images array should not be empty.
                XCTAssertFalse(images.isEmpty, "No images were fetched.")
            case .failure(let error):
                // If the fetch fails, the test fails.
                XCTFail("Failed to fetch images: \(error)")
            }
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchImagesWithInvalidAPIKey() throws {
        do {
            let service = try PexelService(apiKey: invalidAPIKey)
            viewModel = ImageCollectionViewModel(service: service)
            let expectation = XCTestExpectation(description: "Fetch images from Unsplash API with invalid API key")
            
            viewModel.fetchImages(for: "Nature") { result in
                switch result {
                case .success(_):
                    XCTFail("Images were fetched with an invalid API key")
                case .failure(let error):
                    XCTAssert(error is NetworkImageServiceError, "Unexpected error: \(error)")
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 10.0)
        } catch NetworkImageServiceError.invalidAPIKey {
            // Expected error, test passed
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchImageWithValidAPIKey() throws {
        do {
            let service = try PexelService(apiKey: validAPIKey)
            viewModel = ImageCollectionViewModel(service: service)
            let expectation = XCTestExpectation(description: "Fetch image from Unsplash API with valid API key")
            let validURL = URL(string: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png")!
            
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
            let service = try PexelService(apiKey: invalidAPIKey)
            viewModel = ImageCollectionViewModel(service: service)
            let expectation = XCTestExpectation(description: "Fetch image from Unsplash API with invalid API key")
            let validURL = URL(string: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png")!
            
            viewModel.fetchImage(for: validURL) { result in
                switch result {
                case .success(_):
                    XCTFail("Image was fetched with an invalid API key")
                case .failure(let error):
                    XCTAssert(error is NetworkImageServiceError, "Unexpected error: \(error)")
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 10.0)
        } catch NetworkImageServiceError.invalidAPIKey {
            // Expected error, test passed
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchImagesWithEmptySearchTerms() throws {
        let service = try PexelService(apiKey: validAPIKey)
        viewModel = ImageCollectionViewModel(service: service)
        
        let expectation = XCTestExpectation(description: "Fetch query for empty search terms")
        let term = " "
        
        viewModel.fetchImages(for: term) { result in
            switch result {
            case .success( _):
                XCTFail("Image was fetched with empty search term")
            case .failure(let error):
                XCTAssertNotNil(error, "Expected error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchImageWithValidURL() throws {
        let service = try PexelService(apiKey: validAPIKey)
        viewModel = ImageCollectionViewModel(service: service)
        
        let expectation = XCTestExpectation(description: "Fetch image for different URLs")
        
        let url = URL(string: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png")!
        
        viewModel.fetchImage(for: url) { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image, "No image was fetched for URL: \(url)")
            case .failure(let error):
                XCTFail("Failed to fetch image for URL: \(url). Error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchImageWithInvalidURL() throws {
        let service = try PexelService(apiKey: validAPIKey)
        viewModel = ImageCollectionViewModel(service: service)
        
        let expectation = XCTestExpectation(description: "Fetch image for different URLs")
        
        let url = URL(string: "https://invalid-url")!
        
        viewModel.fetchImage(for: url) { result in
            switch result {
            case .success( _):
                XCTFail("Fetch image for invalid URL: \(url)")
            case .failure(let error):
                XCTAssertNotNil(error, "No image was fetched for URL: \(url)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}

