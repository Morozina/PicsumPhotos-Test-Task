//
//  RemoteFeedLoaderTests.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import XCTest
@testable import PicsumPhotos

class MockHTTPClient: HTTPClient {
    var completion: ((HTTPClientResult) -> Void)?
    
    func get(form url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        self.completion = completion
    }
    
    func completeWithSuccess(with data: Data) {
        completion?(.success(data))
    }
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    
    func testSuccesfulAPIResponse() {
        let client  = MockHTTPClient()
        let sut = RemoteFeedLoader(client: client)
        
        let dataString = """
                            [{"id":"0","author":"Alejandro Escamilla","width":5616,"height":3744,"url":"https://unsplash.com/photos/yC-Yzbqy7PY","download_url":"https://picsum.photos/id/0/5616/3744"}]
                         """
        let expectedFeed = [Feed(id: "0", author: "Alejandro Escamilla", width: 5616, height: 3744, url: "https://unsplash.com/photos/yC-Yzbqy7PY", downloadURL: "https://picsum.photos/id/0/5616/3744")]
        
        let expectation = expectation(description: "wait for images to load")
        
        sut.loadFeed(url: anyURL()) { result in
            switch result {
            case .success(let feed):
                
                XCTAssertEqual(feed, expectedFeed)
            default:
                XCTFail("This should not fail and passed instead as this is success case check input and exppected output")
            }
            expectation.fulfill()
        }
        
        client.completeWithSuccess(with: dataString.data(using: .utf8)!)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvalidResponse() {
        let client  = MockHTTPClient()
        let sut = RemoteFeedLoader(client: client)
        
        let dataString = """
                            [{"id":"0","authors":"Alejandro Escamilla","width":5616,"height":3744,"url":"https://unsplash.com/photos/yC-Yzbqy7PY","download_url":"https://picsum.photos/id/0/5616/3744"}]
                         """
        
        let expectation = expectation(description: "wait for images to load")
        
        sut.loadFeed(url: anyURL()) { result in
            switch result {
            case .failure(let error as RemoteFeedLoader.Error):
                XCTAssertEqual(error, RemoteFeedLoader.Error.invalidData)
            default:
                XCTFail("This should not pass and passed instead as this is invalid case check input and exppected output")
            }
            expectation.fulfill()
        }
        
        client.completeWithSuccess(with: dataString.data(using: .utf8)!)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testEmptyResponse() {
        let client  = MockHTTPClient()
        let sut = RemoteFeedLoader(client: client)
        
        let dataString = """
                            []
                         """
        let expectation = expectation(description: "wait for images to load")
        
        sut.loadFeed(url: anyURL()) { result in
            switch result {
            case .success(let feed):
                XCTAssertTrue(feed.isEmpty)
            default:
                XCTFail("This should not fail and passed instead as this is success case check input and exppected output")
            }
            expectation.fulfill()
        }
        
        client.completeWithSuccess(with: dataString.data(using: .utf8)!)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
