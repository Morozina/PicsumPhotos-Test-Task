//
//  DetailViewModel.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import Foundation
import UIKit

class DetailViewModel {
    
    private let imageLoader: FeedImageDataLoader
    private let feed: Feed
    
    private var normalImage: UIImage?
    private var blurImage: UIImage?
    private var grayscaleImage: UIImage?
    
    var stepperValue: Int = 5

    init(feed: Feed, imageLoader: FeedImageDataLoader) {
        self.imageLoader = imageLoader
        self.feed = feed
    }
    
    func loadNormalImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = Endpoint.normalImage(feed.id).url else {
            completion(nil)
            return
        }
        
        guard let image = normalImage else {
            imageLoader.loadImageData(from: url) { [weak self] result in
                if let data = try? result.get() {
                    let image = UIImage(data: data)
                    self?.normalImage = image
                    completion(image)
                }
            }
            return
        }
        completion(image)
    }
    
    func loadBlurImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = Endpoint.blurImage(feed.id).url else {
            completion(nil)
            return
        }
    
        let image: UIImage = {
            let image = UIImage()
            imageLoader.loadImageData(from: url) { [weak self] result in
                guard let strongSelf = self else { return }
                if let data = try? result.get() {
                    let image = UIImage(data: data)
                    self?.blurImage = image
                    Endpoint.Constants.blurValue = String(strongSelf.stepperValue)
                    completion(image)
                }
            }
            return image
        }()
        
        completion(image)
    }
    
    func loadGrayScaleImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = Endpoint.grayScale(feed.id).url else {
            completion(nil)
            return
        }
        
        guard let image = grayscaleImage else {
            imageLoader.loadImageData(from: url) { [weak self] result in
                if let data = try? result.get() {
                    let image = UIImage(data: data)
                    self?.grayscaleImage = image
                    completion(image)
                }
            }
            return
        }
        
        completion(image)
    }
    
    var authorName: String {
        return "Author: \(feed.author)"
    }
    
    var dimensions: String {
        return "Height: \(feed.height) Width: \(feed.width)"
    }
    
    var url: String {
        return "URL: \(feed.url)"
    }
    
    var downloadURL: String {
        return "Download URL: \(feed.downloadURL)"
    }
}
