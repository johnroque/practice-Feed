//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 2/15/21.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
