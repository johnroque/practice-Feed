//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 2/3/21.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
