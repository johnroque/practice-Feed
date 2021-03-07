//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 2/6/21.
//

import Foundation

//public enum HTTPClientResult {
//    case success(Data, HTTPURLResponse)
//    case failure(Error)
//}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
