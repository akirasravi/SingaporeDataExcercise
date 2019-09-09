//
//  SingaporeDataViewControllerTests.swift
//  SingaporeDataTests
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import XCTest
@testable import SingaporeData

class SingaporeDataViewControllerTests: XCTestCase {
    var viewController: SingaporeDataViewController?
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "SingaporeDataViewController") as? SingaporeDataViewController
        viewController?.viewModel.service = ServiceUtilMock()
        _ = viewController?.view
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewController() {
        XCTAssertNotNil(viewController?.singaporeDataTableView,
                        "Controller should have a tableview")
                
        XCTAssertEqual(viewController?.viewModel.processedSingaporeData.count, 2,
                       "DataSource should have correct number of years")
    }
    
    
}
