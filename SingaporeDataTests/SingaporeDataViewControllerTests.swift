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
        viewController = nil
        super.tearDown()
    }
    
    func testViewController() {
        
        XCTAssertNotNil(viewController?.singaporeDataTableView.delegate)
        
        XCTAssertNotNil(viewController?.view,
                        "Controller should have a view")
        
        XCTAssertNotNil(viewController?.singaporeDataTableView,
                        "Controller should have a tableview")
                
        XCTAssertEqual(viewController?.viewModel.processedSingaporeData.count, 2,
                       "DataSource should have correct number of years")
        

        XCTAssertTrue((viewController?.conforms(to: UITableViewDataSource.self))!)
        
   
        XCTAssertTrue((viewController?.responds(to: #selector(viewController?.tableView(_:numberOfRowsInSection:))))!)
        XCTAssertTrue((viewController?.responds(to: #selector(viewController?.tableView(_:cellForRowAt:))))!)
               
        XCTAssertEqual(viewController?.tableView((viewController?.singaporeDataTableView)!, numberOfRowsInSection: 0), 2)
        
        XCTAssertEqual(viewController?.tableView((viewController?.singaporeDataTableView)!, heightForRowAt: IndexPath(row: 0, section: 0)), 48)
        
        let cell = viewController?.tableView((viewController?.singaporeDataTableView)!, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell)
        
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "singaporeDataCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
        
        viewController?.tableView((viewController?.singaporeDataTableView)!, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        
        let cell2 = viewController?.tableView((viewController?.singaporeDataTableView)!, cellForRowAt: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(cell2?.reuseIdentifier, "singaporeDataExpandedCell")
        
        XCTAssertNotNil(cell2)
       
    }
}
