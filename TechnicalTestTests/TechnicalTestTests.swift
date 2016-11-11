//
//  TechnicalTestTests.swift
//  TechnicalTestTests
//
//  Created by Fayyazuddin Syed on 2016-11-07.
//  Copyright © 2016 Fayyazuddin Syed. All rights reserved.
//

import XCTest
@testable import TechnicalTest

class TechnicalTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLaunchable() {
        XCTAssertTrue(true)
    }
    
    func testConnection() {
        let reachablilityExpectation = expectation(description: "reachability")
        
        if let url = URL(string: "https://api-server.essenceprototyping.com:999/photos/search/?searchString") {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (url: Data?, response: URLResponse?, error: Error?) in
                
                if error == nil {
                    reachablilityExpectation.fulfill()
                }
                
            })
            task.resume()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
