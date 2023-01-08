//
//  ImageLoader.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import Foundation

typealias Root = [Feed]

protocol FeedLoader {
    typealias Result = Swift.Result<[Feed] , Error>
    func loadFeed(url: URL, completion: @escaping (FeedLoader.Result) -> Void)
}

protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)
}
