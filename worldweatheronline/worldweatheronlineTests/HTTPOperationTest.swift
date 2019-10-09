//
//  HTTPOperationTest.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//



import XCTest
@testable import worldweatheronline

class HTTPOperationTest: XCTestCase {

    var operationQueue:OperationQueue?
    
    override func setUp() {
        operationQueue = OperationQueue()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        operationQueue = nil
    }

    func testCorrect_URL() {
        if let url = URL(string: "https://www.google.com/") {
            let exp = expectation(description: "\(#function)\(#line)")
            let operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                exp.fulfill()
            })
        
            operationQueue?.addOperation(operation)
            waitForExpectations(timeout: 40, handler: nil)
        }
        else {
            XCTAssert(false,"Unable to intialize url")
        }
    }

    func test_combination_URLMultiple() {
        let exp = expectation(description: "\(#function)\(#line)")
        exp.expectedFulfillmentCount = 3
        if let url = URL(string: "https://www.apple.com/") {
            let operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                print ("1 fulfill")
                exp.fulfill()
            })
            operationQueue?.addOperation(operation)
        }
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
            let operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                print ("1 fulfill")
                exp.fulfill()
            })
            operationQueue?.addOperation(operation)
        }
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
            let operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                print ("1 fulfill")
                exp.fulfill()
            })
            operationQueue?.addOperation(operation)
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }

    func testCorrect_URLMultiple() {
        if let url = URL(string: "https://www.google.com/") {
            let exp = expectation(description: "\(#function)\(#line)")
            exp.expectedFulfillmentCount = 4
            var operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                print ("1 fulfill")
                exp.fulfill()
            })
            operationQueue?.addOperation(operation)
            operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                print ("2 fulfill")
                exp.fulfill()
            })
            operationQueue?.addOperation(operation)
            operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                print ("3 fulfill")
                exp.fulfill()
            })
            operationQueue?.addOperation(operation)
            operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                print ("4 fulfill")
                exp.fulfill()
            })
            operationQueue?.addOperation(operation)
            
            waitForExpectations(timeout: 40, handler: nil)
        }
        else {
            XCTAssert(false,"Unable to intialize url")
        }
    }

    func testBad_URL() {
        if let url = URL(string: "https://www.googe.com/") {
            let exp = expectation(description: "\(#function)\(#line)")
            let operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error != nil)
                exp.fulfill()
            })
            
            operationQueue?.addOperation(operation)
            waitForExpectations(timeout: 40, handler: nil)
        }
        else {
            XCTAssert(false,"Unable to intialize url")
        }
    }
    
    func test_http_URL() {
        if let url = URL(string: "http://httpbin.org/post") {
            let exp = expectation(description: "\(#function)\(#line)")
            let operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error != nil)
                exp.fulfill()
            })
            
            operationQueue?.addOperation(operation)
            waitForExpectations(timeout: 40, handler: nil)
        }
        else {
            XCTAssert(false,"Unable to intialize url")
        }
    }

    func test_https_URL_method_not_allowed() {
        if let url = URL(string: "https://httpbin.org/post") {
            let exp = expectation(description: "\(#function)\(#line)")
            let operation = HTTPOperation(url: url, completionHandler: { (data, error) in
                XCTAssert(error != nil)
                if let httpError = error {
                    if case HTTPError.badHTTPStatus(let reason, let httpCode) =  httpError {
                        XCTAssert(httpError.code == 405,"HTTP Error code dose not match")
                        XCTAssert(httpError.code == httpCode,"HTTP Error code dose not match")
                       XCTAssert(reason == httpError.localizedDescription,"HTTP Error message dose not match")
                   }
                    else {
                        XCTAssert(false,"Invalid error type")
                    }
                }
                exp.fulfill()
            })
            operationQueue?.addOperation(operation)
            waitForExpectations(timeout: 40, handler: nil)
        }
        else {
            XCTAssert(false,"Unable to intialize url")
        }
    }
}
