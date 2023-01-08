//
//  CellController.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import Foundation
import UIKit

private let reuseIdentifier = "Cell"

class CellController {
    
    private let imageDataLoader: FeedImageDataLoader
    private let feedImage: Feed
    
    init(feedImage: Feed, imageDataLoader: FeedImageDataLoader) {
        self.feedImage = feedImage
        self.imageDataLoader = imageDataLoader
    }
    
    func view(for collectionView: UICollectionView, indexpath: IndexPath) -> ImageCollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexpath) as! ImageCollectionViewCell
        
        if let url = Endpoint.image(feedImage.id).url {
           loadImage(url: url, imageDataLoader: imageDataLoader, for: collectionViewCell)
        }
        
        return collectionViewCell
    }
    
    var feed: Feed {
        return self.feedImage
    }
    
    private func loadImage(url: URL, imageDataLoader: FeedImageDataLoader, for cell: ImageCollectionViewCell) {
        guard let url =  Endpoint.image(feedImage.id).url else { return }
        cell.activityView.startAnimating()
        imageDataLoader.loadImageData(from: url) { result in
            DispatchQueue.main.async {
                cell.activityView.stopAnimating()
                if let imageData = try? result.get() {
                    cell.imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
}

