//
//  SingaporeDataUITests.swift
//  SingaporeDataUITests
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import XCTest

class SingaporeDataUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSingaporeDataUI() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        let yearHeader = tablesQuery.staticTexts["Year"]
        XCTAssertTrue(yearHeader.exists)
        
        let consumptionHeader = tablesQuery.staticTexts["Consumption"]
        XCTAssertTrue(consumptionHeader.exists)
       
    }

}
