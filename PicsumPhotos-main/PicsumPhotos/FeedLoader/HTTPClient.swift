//
//  HTTPClient.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import Foundation

protocol HTTPClient {
    typealias HTTPClientResult = Swift.Result<Data, Error>
    func get(form url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

class URLSessionHTTPClient: HTTPClient {
    
    private let session : URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(form url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}
