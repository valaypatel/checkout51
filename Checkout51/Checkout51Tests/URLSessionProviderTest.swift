//
//  URLSessionProviderTest.swift
//  Checkout51Tests
//
//  Created by Patel, Valay on 2019-07-31.
//  Copyright © 2019 FirstAim. All rights reserved.
//

import XCTest
import Mockingjay

class URLSessionProviderTest: XCTestCase {
    
    private let sessionProvider = URLSessionProvider()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServerError() {
        let expectation = self.expectation(description: "Server Error")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        stub(everything, http(500))
        self.measure {
            sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
                switch response {
                case .success(_):
                    XCTFail()
                    
                case let .failure(error):
                    XCTAssertEqual(error,NetworkError.server)
                    
                    
                }
                
                expectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 5, handler: {(error:Error?) in
            XCTAssert((error == nil), error?.localizedDescription ?? "Failed with unknown error")
        })
        
    }
    
    
    func testNetworkError() {
        let expectation = self.expectation(description: "Server Error")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        stub(everything, http(400))
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case .success(_):
                XCTFail()
                
            case let .failure(error):
                XCTAssertEqual(error,NetworkError.network)
                
                
            }
            
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5, handler: {(error:Error?) in
            XCTAssert((error == nil), error?.localizedDescription ?? "Failed with unknown error")
        })
        
    }
    
    
    func testWrongData() {
        let expectation = self.expectation(description: "fetch Wrong Data")
        let body = [ "test": "test"]
        stub(uri("https://api.myjson.com/bins/14xyzl"), json(body))
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case .success(_):
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error,NetworkError.parsingError)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5, handler: {(error:Error?) in
            XCTAssert((error == nil), error?.localizedDescription ?? "Failed with unknown error")
        })
        
    }
    
    
    func testNoData() {
        let expectation = self.expectation(description: "No Data")
        
        stub(uri("https://api.myjson.com/bins/14xyzl"), http(200))
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case .success(_):
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error,NetworkError.parsingError)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 50, handler: {(error:Error?) in
            XCTAssert((error == nil), error?.localizedDescription ?? "Failed with unknown error")
        })
        
    }
    
    func testProperData() {
        let expectation = self.expectation(description: "No Data")
        let offer = ["offer_id":"40408",
                     "name":"Buy 2: Select TRISCUIT Crackers",
                     "image_url":"https://d3bx4ud3idzsqf.cloudfront.net/public/production/6840/67561_1535141624.jpg",
                     "cash_back":1.0] as [String : Any]
        let body = [ "batch_id": 0,"offers":[offer]] as [String : Any];
        stub(uri("https://api.myjson.com/bins/14xyzl"), json(body))
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case let .success(offerBatch):
                XCTAssertEqual(offerBatch.offers.first?.offer_id,"40408")
            case let .failure(error):
                XCTAssertEqual(error,NetworkError.parsingError)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 50, handler: {(error:Error?) in
            XCTAssert((error == nil), error?.localizedDescription ?? "Failed with unknown error")
        })
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
