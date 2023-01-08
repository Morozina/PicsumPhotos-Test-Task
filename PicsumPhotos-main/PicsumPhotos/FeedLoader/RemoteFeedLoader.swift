//
//  RemoteFeedLoader.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import Foundation

class RemoteFeedLoader: FeedLoader {
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadFeed(url: URL, completion: @escaping (FeedLoader.Result) -> Void) {
        
        client.get(form: url) { result in
            switch result {
            case .success( let data):
                do {
                    let items = try self.feed(from: data)
                    completion(items)
                } catch {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    func feed(from data: Data) throws -> FeedLoader.Result {
        if let feed = try? JSONDecoder().decode(Root.self, from: data) {
            return .success(feed)
        }
        
        return .failure(Error.invalidData)
    }
}
