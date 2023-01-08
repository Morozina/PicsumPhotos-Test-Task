//
//  SceneDelegate.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var composer = UIComposer()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let client = URLSessionHTTPClient(session: URLSession.shared)
        let remoteFeedLoader = RemoteFeedLoader(client: client)
        let imageDataLoader = RemoteFeedImageDataLoader(client: client)
        
        let controller = composer.feedViewcontroller(feedLoader: remoteFeedLoader, imageLoader: imageDataLoader)

        window?.backgroundColor = .white
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}
