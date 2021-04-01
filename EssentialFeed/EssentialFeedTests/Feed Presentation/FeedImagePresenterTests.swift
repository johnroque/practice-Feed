//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by John Roque Jorillo on 4/2/21.
//

import XCTest

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    func display(_ model: FeedImageViewModel)
}

final class FeedImagePresenter {
    private let view: FeedImageView
    
    init(view: FeedImageView) {
        self.view = view
    }
}

class FeedImagePresenterTests: XCTestCase {

    func test_init_doesNotMessageToView() {
        let view = ViewSpy()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no message to view")
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: FeedImageView {
        private(set) var messages: [Any] = []
        
        func display(_ model: FeedImageViewModel) {
            messages.append(model)
        }
    }

}
