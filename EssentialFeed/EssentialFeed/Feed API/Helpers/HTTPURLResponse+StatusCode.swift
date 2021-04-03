//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by John Roque Jorillo on 4/3/21.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
