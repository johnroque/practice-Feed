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
        
        sut.validateCache()
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
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
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimeStamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesCacheOnExpiration() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expirationCache = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: expirationCache)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_deletesCacheExpired() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expiredCache = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: expiredCache)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        sut?.validateCache()
        
        sut = nil
        store.completeRetrieval(with: anyNSError())
    
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
        trackForMemoryLeak(store, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, store)
    }
    
}
