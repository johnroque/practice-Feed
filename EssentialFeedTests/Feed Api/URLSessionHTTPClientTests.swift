//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by John Roque Jorillo on 2/8/21.
//

import XCTest
import EssentialFeed

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
        let url = anyURL()
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
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)! as NSError
        
        XCTAssertEqual(receivedError.code, requestError.code)
        XCTAssertEqual(receivedError.domain, requestError.domain)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
//        URLProtocolStub.stub(data: nil, response: nil, error: nil)
//
//        let exp = expectation(description: "Wait for completion")
//
//        makeSUT().get(from: anyURL()) { result in
//            switch result {
//            case .failure:
//                break
//            default:
//                XCTFail("Expected failure got \(result) instead")
//            }
//
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
//        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let requestData = anyData()
        let requestResponse = anyHTTPURLResponse()
        
        let values = resultValuesFor(data: requestData, response: requestResponse, error: nil)
        
        XCTAssertEqual(values?.data, requestData)
        XCTAssertEqual(values?.response.url, requestResponse.url)
        XCTAssertEqual(values?.response.statusCode, requestResponse.statusCode)
        
//        URLProtocolStub.stub(data: requestData, response: requestResponse, error: nil)
//
//        let exp = expectation(description: "Wait for completion")
//
//        makeSUT().get(from: anyURL()) { (result) in
//            switch result {
//            case let .success(receivedData, receivedResponse):
//                XCTAssertEqual(receivedData, requestData)
//                XCTAssertEqual(receivedResponse.url, requestResponse.url)
//                XCTAssertEqual(receivedResponse.statusCode, requestResponse.statusCode)
//            default:
//                XCTFail("Expected failure got \(result) instead")
//            }
//
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let requestResponse = anyHTTPURLResponse()
        let emptyData = Data()
        
        let values = resultValuesFor(data: nil, response: requestResponse, error: nil)
        
        XCTAssertEqual(values?.data, emptyData)
        XCTAssertEqual(values?.response.url, requestResponse.url)
        XCTAssertEqual(values?.response.statusCode, requestResponse.statusCode)
        
//        URLProtocolStub.stub(data: nil, response: requestResponse, error: nil)
//
//        let exp = expectation(description: "Wait for completion")
//
//        makeSUT().get(from: anyURL()) { (result) in
//            switch result {
//            case let .success(receivedData, receivedResponse):
//                let emptyData = Data()
//                XCTAssertEqual(receivedData, emptyData)
//                XCTAssertEqual(receivedResponse.url, requestResponse.url)
//                XCTAssertEqual(receivedResponse.statusCode, requestResponse.statusCode)
//            default:
//                XCTFail("Expected failure got \(result) instead")
//            }
//
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
//        URLProtocolStub.stub(data: data, response: response, error: error)
//        let sut = makeSUT(file: file, line: line)
//        let exp = expectation(description: "Wait for completion")
//
//        var receivedValues: (data: Data, response: HTTPURLResponse)?
//        sut.get(from: anyURL()) { result in
//            switch result {
//            case let .success(data, response):
//                receivedValues = (data, response)
//            default:
//                XCTFail("Expected success got \(result) instead", file: file, line: line)
//            }
//
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 1.0)
//        return receivedValues
        
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        var receivedValues: (data: Data, response: HTTPURLResponse)?
        switch result {
        case let .success(data, response):
            receivedValues = (data, response)
        default:
            XCTFail("Expected success got \(result) instead", file: file, line: line)
        }
        
        return receivedValues
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        URLProtocolStub.stub(data: data, response: response, error: error)
//        let sut = makeSUT(file: file, line: line)
//        let exp = expectation(description: "Wait for completion")
//
//        var receivedError: Error?
//        sut.get(from: anyURL()) { result in
//            switch result {
//            case let .failure(error):
//                receivedError = error
//            default:
//                XCTFail("Expected failure got \(result) instead", file: file, line: line)
//            }
//
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 1.0)
//        return receivedError
        
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        var receivedError: Error?
        switch result {
        case let .failure(error):
            receivedError = error
        default:
            XCTFail("Expected failure got \(result) instead", file: file, line: line)
        }
        
        return receivedError
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> HTTPClientResult {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClientResult!
        sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
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
            return request
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }
            
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

