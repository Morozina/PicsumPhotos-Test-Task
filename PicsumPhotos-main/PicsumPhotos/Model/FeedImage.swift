//
//  FeedImage.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import Foundation

struct Feed: Equatable, Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
