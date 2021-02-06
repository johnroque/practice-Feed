//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 2/3/21.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult<Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] (result) in
            guard let _ = self else { return }
            
            switch result {
            case .success(let data, let httpResponse):
                completion(FeedItemMapper.map(data, from: httpResponse))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
}
