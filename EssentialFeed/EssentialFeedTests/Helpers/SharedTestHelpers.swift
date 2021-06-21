//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by John Roque Jorillo on 2/17/21.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}
