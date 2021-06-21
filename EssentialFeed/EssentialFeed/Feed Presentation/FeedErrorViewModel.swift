//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 4/2/21.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
