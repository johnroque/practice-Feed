//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 4/4/21.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
