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
    
    private var sessionProvider:URLSessionProvider!
    
    override func setUp() {
        super.setUp()
        sessionProvider = URLSessionProvider()
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
        var responseError:NetworkError?
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case .success(_):
                XCTFail()
            case let .failure(error):
                responseError = error
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(responseError,NetworkError.server)
        
    }
    
    
    func testNetworkError() {
        let expectation = self.expectation(description: "Server Error")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        stub(everything, http(400))
        var responseError:NetworkError?
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case .success(_):
                XCTFail()
                
            case let .failure(error):
                responseError = error
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(responseError,NetworkError.network)
    }
    
    
    func testWrongData() {
        let expectation = self.expectation(description: "fetch Wrong Data")
        let body = [ "test": "test"]
        stub(uri("https://api.myjson.com/bins/14xyzl"), json(body))
        var responseError:NetworkError?
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case .success(_):
                XCTFail()
            case let .failure(error):
                responseError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(responseError,NetworkError.parsingError)
    }
    
    
    func testNoData() {
        let expectation = self.expectation(description: "No Data")
        
        stub(uri("https://api.myjson.com/bins/14xyzl"), http(200))
        var responseError:NetworkError?
        
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case .success(_):
                XCTFail()
            case let .failure(error):
                responseError = error
                
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(responseError,NetworkError.parsingError)
    }
    
    func testProperData() {
        let expectation = self.expectation(description: "No Data")
        let offer = ["offer_id":"40408",
                     "name":"Buy 2: Select TRISCUIT Crackers",
                     "image_url":"https://d3bx4ud3idzsqf.cloudfront.net/public/production/6840/67561_1535141624.jpg",
                     "cash_back":1.0] as [String : Any]
        let body = [ "batch_id": 0,"offers":[offer]] as [String : Any];
        stub(uri("https://api.myjson.com/bins/14xyzl"), json(body))
        var offerResponse: OfferBatch?
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case let .success(offerBatch):
                offerResponse = offerBatch
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(offerResponse?.offers.first?.offer_id,"40408")
        
    }

    
}
