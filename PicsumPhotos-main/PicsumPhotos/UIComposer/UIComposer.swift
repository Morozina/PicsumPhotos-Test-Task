//
//  UIComposer.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import Foundation
import UIKit

class UIComposer {
    private var viewController: ImageFeedCollectionViewController?

    func feedViewcontroller(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> UIViewController {
        let client = URLSessionHTTPClient(session: URLSession.shared)
        let imageDataLoader = RemoteFeedImageDataLoader(client: client)
        let remoteFeedLoader = RemoteFeedLoader(client: client)
        let viewModel = FeedImageViewModel(feedLoader: remoteFeedLoader)
        let controller = ImageFeedCollectionViewController(viewModel: viewModel)
        controller.delegate = self
        self.viewController = controller
        viewModel.onFeedLoad = { [weak self] feed in
            self?.mapToCellController(feed: feed, on: controller, imageDataLoader: imageDataLoader)
        }
        return UINavigationController(rootViewController: controller)
    }
    
    private func mapToCellController(feed: [Feed], on viewController: ImageFeedCollectionViewController, imageDataLoader: FeedImageDataLoader) {
        DispatchQueue.main.async {
            viewController.cellControllers += feed.map { CellController(feedImage: $0, imageDataLoader: imageDataLoader) }
        }
    }
}

extension UIComposer: ImageFeedCollectionViewControllerDelegate {
    func didSelect(feed: Feed, on viewController: ImageFeedCollectionViewController) {
        let client = URLSessionHTTPClient(session: URLSession.shared)
        let imageLoader = RemoteFeedImageDataLoader(client: client)
        
        let viewMiodel = DetailViewModel(feed: feed, imageLoader: imageLoader)
        let detailController = DetailViewController(viewModel: viewMiodel)
        viewController.show(detailController, sender: nil)
    }
}
