//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 2/3/21.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
