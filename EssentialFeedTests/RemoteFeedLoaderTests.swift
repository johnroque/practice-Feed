//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by John Roque Jorillo on 2/3/21.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        // Arrange
        let (_, client) = makeSUT()
        
        // Act
        
        // Assert
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        // Arrange
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
    
        // Act
        sut.load() { _ in }
        
        // Assert
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        // Arrange
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
    
        // Act
        sut.load() { _ in }
        sut.load() { _ in }
        
        // Assert
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        // Arrange
        let (sut, client) = makeSUT()
        
        let clientError = NSError(domain: "Test",
                               code: 0)
        expect(sut, error: .connectivity) {
            client.complete(with: clientError)
        }
        
//        // Act
//        var capturedError = [RemoteFeedLoader.Error]()
//        sut.load { capturedError.append($0) }
//
//        let clientError = NSError(domain: "Test",
//                               code: 0)
//        //client.completions[0](clientError) // invokes the completion
//        client.complete(with: clientError)
        
        // Assert
//        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500].enumerated()
        
        samples.forEach { (index, code) in
            expect(sut, error: .invalidData) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HttpResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, error: .invalidData) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoIntemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        var capturedResult = [RemoteFeedLoader.Result]()
        sut.load { capturedResult.append($0) }
        
        let emptyListJSON = "{\"items\": []}".data(using: .utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON!)
        
        XCTAssertEqual(capturedResult, [.success([])])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, error: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResult = [RemoteFeedLoader.Result]()
        sut.load { capturedResult.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResult, [.failure(error)], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            messages.map{ $0.url }
        }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        // MARK: Helper
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: messages[index].url,
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            messages[index].completion(.success(data, response!))
        }
    }
    
}
