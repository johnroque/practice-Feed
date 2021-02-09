//
//  FeedItemsMappter.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 2/6/21.
//

import Foundation

internal final class FeedItemMapper {
    
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            return items.map { $0.item }
        }
    }

    private struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id,
                            description: description,
                            location: location,
                            imageURL: image)
        }
    }

    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let items = try? JSONDecoder().decode(Root.self, from: data).feed else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        
        return .success(items)
    }
}
