//
//  ValidateFeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by John Roque Jorillo on 2/17/21.
//

import XCTest
import EssentialFeed

class ValidateFeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_hasNoSideEffectsOnRetrieveError() {
        let (sut, store) = makeSUT()
        
        sut.validateCache() { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache() { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
//    func test_load_doesNotDeleteLessThanSevenDaysOldCache() {
//        let feed = uniqueImageFeed()
//        let fixedCurrentDate = Date()
//        let lessThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: 7).adding(seconds: 1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//
//        sut.validateCache()
//        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimeStamp)
//
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//    }
//
//    func test_validateCache_deletesSevenDaysOldCache() {
//        let feed = uniqueImageFeed()
//        let fixedCurrentDate = Date()
//        let sevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//
//        sut.validateCache()
//        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimeStamp)
//
//        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
//    }
//
//    func test_validateCache_deletesMoreThanSevenDaysOldCache() {
//        let feed = uniqueImageFeed()
//        let fixedCurrentDate = Date()
//        let moreThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//
//        sut.validateCache()
//        store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysOldTimeStamp)
//
//        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
//    }
    
    func test_load_doesNotDeleteNonExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimeStamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache() { _ in }
        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimeStamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesCacheOnExpiration() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expirationCache = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache() { _ in }
        store.completeRetrieval(with: feed.local, timestamp: expirationCache)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_deletesCacheExpired() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expiredCache = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache() { _ in }
        store.completeRetrieval(with: feed.local, timestamp: expiredCache)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        sut?.validateCache() { _ in }
        
        sut = nil
        store.completeRetrieval(with: anyNSError())
    
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_failsOnDeletionErrorOfFailedRetrieval() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        expect(sut, toCompleteWith: .failure(deletionError), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletion(with: deletionError)
        })
    }

    func test_validateCache_succeedsOnSuccessfulDeletionOfFailedRetrieval() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletionSuccessFully()
        })
    }
    
    func test_validateCache_succeedsOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: LocalFeedLoader.ValidationResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.validateCache { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success):
                break

            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
    
}
