//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by John Roque Jorillo on 3/7/21.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UIViewController {
    private var loader: FeedViewControllerTests.LoaderSpy?
    
    convenience init(loader: FeedViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load { _ in }
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCounter, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCounter, 1)
    }
    
    class LoaderSpy: FeedLoader {
        private(set) var loadCallCounter: Int = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCounter += 1
        }
    }

}
