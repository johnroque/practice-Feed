//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by John Roque Jorillo on 3/30/21.
//

struct FeedErrorViewModel {
    let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
