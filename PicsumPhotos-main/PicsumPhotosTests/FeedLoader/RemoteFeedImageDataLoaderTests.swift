//
//  RemoteFeedImageDataLoaderTests.swift
//  PicsumPhotosTests
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import XCTest
@testable import PicsumPhotos

final class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func testEmptyData() {
        let client = MockHTTPClient()
        let sut = RemoteFeedImageDataLoader(client: client)
        let exp = expectation(description: "Wait for load completion")
        
        let emptyData = Data()
        
        sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let (.failure(receivedError as NSError)):
                XCTAssertEqual(receivedError, RemoteFeedImageDataLoader.Error.invalidData as NSError)
            default:
                XCTFail("Expecting failure")
            }
        }
        
        client.completeWithSuccess(with: emptyData)
        exp.fulfill()
        wait(for: [exp], timeout: 1.0)
    }
    
    func testNonEmptyData() {
        let client = MockHTTPClient()
        let sut = RemoteFeedImageDataLoader(client: client)
        let exp = expectation(description: "Wait for load completion")
        
        let nonEmptyData = "npn-empty data".data(using: .utf8)!
        
        sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let (.success(data)):
                XCTAssertEqual(data, nonEmptyData)
            default:
                XCTFail("Expecting success")
            }
        }
        
        client.completeWithSuccess(with: nonEmptyData)
        exp.fulfill()
        wait(for: [exp], timeout: 1.0)
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
