//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 2/14/21.
//

import Foundation

//public typealias RetrieveCachedFeedResult = Result<CachedFeed, Error>

//public enum RetrieveCachedFeedResult {
//    case success(CachedFeed)
//    case failure(Error)
//}

//public enum CachedFeed {
//    case empty
//    case found(feed: [LocalFeedImage], timestamp: Date)
//}

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    typealias DeletionResult = Error?
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Error?
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
