//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by John Roque Jorillo on 2/8/21.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { (_, _, error) in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
   
    // MARK: - Subclass mocking
//    func test_getFromURL_createsDataTaskWithURL() {
//        let url = URL(string: "http://any-url.com")!
//        let session = URLSessionSpy()
//        let sut = URLSessionHTTPClient(session: session)
//
//        sut.get(from: url)
//
//        XCTAssertEqual(session.receivedURLs, [url])
//    }
    
//    func test_getFromURL_resumeDataTaskWithURL() {
//        let url = URL(string: "http://any-url.com")!
//        let session = URLSessionSpy()
//
//        let task = URLSessionDataTaskSpy()
//        session.stub(url: url, task: task)
//
//        let sut = URLSessionHTTPClient(session: session)
//
//        sut.get(from: url) { _ in }
//
//        XCTAssertEqual(task.resumeCallCount, 1)
//    }
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInteceptingRequests()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        
        let url = URL(string: "http://any-url.com")!
        
        let exp = expectation(description: "Wait for completion")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let exp = expectation(description: "Wait for completion")
        
        makeSUT().get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.code, error.code)
                XCTAssertEqual(receivedError.domain, error.domain)
            default:
                XCTFail("Expected failure with lerror \(error), got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    // URLProtocol
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error? = nil) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInteceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            requestObserver?(request)
            return request
        }
        
        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() { }
    }
    
    
    
    
    
    // Subclass mocking
//    private class URLSessionSpy: URLSession {
//        var receivedURLs = [URL]()
//
//        private var stubs = [URL: Stub]()
//
//        private struct Stub {
//            let task: URLSessionDataTask
//            let error: Error?
//        }
//
//        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
//            stubs[url] = Stub.init(task: task, error: error)
//        }
//
//        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//            receivedURLs.append(url)
//            guard let stub = stubs[url] else {
//                fatalError("Couln't find stub for \(url)")
//            }
//
//            completionHandler(nil, nil, stub.error)
//            return stub.task
//        }
//    }
//
//    private class FakeURLSessionDataTask: URLSessionDataTask {
//        override func resume() {
//
//        }
//    }
//    private class URLSessionDataTaskSpy: URLSessionDataTask {
//        var resumeCallCount = 0
//
//        override func resume() {
//            resumeCallCount += 1
//        }
//    }
}

