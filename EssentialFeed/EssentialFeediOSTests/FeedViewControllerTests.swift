//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by John Roque Jorillo on 3/7/21.
//

import XCTest

final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCounter, 0)
    }
    
    class LoaderSpy {
        private(set) var loadCallCounter: Int = 0
    }

}
