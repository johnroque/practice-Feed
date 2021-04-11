//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by John Roque Jorillo on 4/11/21.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
//        let url = URL(string: "https://essentialdeveloper.com/feed-case-study/test-api/feed")!
//        
//        //        "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5d1c78f21e661a0001ce7cfd/1562147059075/feed-case-study-v1-api-feed.json"
//        
//        let session = URLSession(configuration: .ephemeral)
//        let client = URLSessionHTTPClient(session: session)
//        let feedLoader = RemoteFeedLoader(url: url, client: client)
//        let imageLoader = RemoteFeedImageDataLoader(client: client)
//        
//        let feedViewController = FeedUIComposer.feedComposeWith(feedLoader: feedLoader, imageLoader: imageLoader)
//        
//        window?.rootViewController = feedViewController
    }

}

