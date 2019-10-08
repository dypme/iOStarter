//
//  iOS_StarterTests.swift
//  iOS_StarterTests
//
//  Created by Crocodic Studio on 28/08/19.
//  Copyright © 2019 Crocodic Studio. All rights reserved.
//

import XCTest
@testable import iOS_Starter

class iOS_StarterTests: XCTestCase {

    let viewModel = LoginVM()
    
    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequestLoginFailed() {
        let expect = expectation(description: "Login with data failed")
        
        viewModel.loginRequest(userid: "", password: "", onFailed: { (message) in
            XCTAssertTrue(true)
            expect.fulfill()
        }) { (message) in
            XCTAssertTrue(false)
            expect.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testRequestLoginSuccess() {
        let expect = expectation(description: "Login with data not fill all")
        
        viewModel.loginRequest(userid: "mail@mail", password: "123456", onFailed: { (message) in
            XCTAssertTrue(false, message)
            expect.fulfill()
            
        }) { (message) in
            XCTAssertTrue(true)
            expect.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
