//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by John Roque Jorillo on 3/13/21.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL,  completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
