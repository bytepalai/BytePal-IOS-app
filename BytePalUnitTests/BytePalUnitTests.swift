//
//  BytePalUnitTests.swift
//  BytePalUnitTests
//
//  Created by may on 8/6/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import XCTest
@testable import BytePal

class AuthenticationTests: XCTestCase {
    
    func testLogin() {
        let email: String = "scott@gmail.com"
        let password: String = "password123"
        let userID: String = Authentication().login(email: email, password: password)
        XCTAssertEqual(userID, "$2b$12$GMyMmsUMqtZPVTD.oEA1.eNjWc.HRztT5tYx91uK1jFdDijtVlNCG")
    }
    
    

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
