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
        viewController?.viewModel.delegate = viewController
        _ = viewController?.view
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testViewControllerTableView() {
        
        XCTAssertNotNil(viewController?.singaporeDataTableView.delegate)
        
        XCTAssertNotNil(viewController?.view,
                        "Controller should have a view")
        
        XCTAssertNotNil(viewController?.singaporeDataTableView,
                        "Controller should have a tableview")
                
        XCTAssertEqual(viewController?.viewModel.processedSingaporeData.count, 3,
                       "DataSource should have correct number of years")
        

        XCTAssertTrue((viewController?.conforms(to: UITableViewDataSource.self))!)
        
        
        XCTAssertTrue((viewController?.responds(to: #selector(viewController?.tableView(_:numberOfRowsInSection:))))!)
        
        
        XCTAssertTrue((viewController?.responds(to: #selector(viewController?.tableView(_:cellForRowAt:))))!)
               
        XCTAssertEqual(viewController?.tableView((viewController?.singaporeDataTableView)!, numberOfRowsInSection: 0), 3)
        
        XCTAssertEqual(viewController?.tableView((viewController?.singaporeDataTableView)!, heightForRowAt: IndexPath(row: 0, section: 0)), 48)
        
        let cell = viewController?.tableView((viewController?.singaporeDataTableView)!, cellForRowAt: IndexPath(row: 1, section: 0))
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "singaporeDataCell"

        XCTAssertNotNil(cell)
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
 
    }
    
    
    func testExpansionAndCollapseOfTableRow() {
        self.viewController?.tableView((self.viewController?.singaporeDataTableView)!, didSelectRowAt: IndexPath(row: 0, section: 0)) //expand
        
        
        let expectedReuseIdentifier = "singaporeDataExpandedCell"
        
        let expectation = XCTestExpectation(description: "wait until didSelectRowAt done in main thread")
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        
        let cell = self.viewController?.tableView((self.viewController?.singaporeDataTableView)!, cellForRowAt: IndexPath(row: 1, section: 0))
        let actualReuseIdentifer = cell?.reuseIdentifier

        XCTAssertNotNil(cell)
        XCTAssertEqual(expectedReuseIdentifier, actualReuseIdentifer)
        
        self.viewController?.tableView((self.viewController?.singaporeDataTableView)!, didSelectRowAt: IndexPath(row: 0, section: 0)) //collapse
        
        let expectation2 = XCTestExpectation(description: "wait until didSelectRowAt done in main thread")
        
        DispatchQueue.main.async {
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 10.0)
        
        let cell2 = self.viewController?.tableView((self.viewController?.singaporeDataTableView)!, cellForRowAt: IndexPath(row: 1, section: 0))
        XCTAssertNotNil(cell2)
        XCTAssertEqual("singaporeDataCell", cell2?.reuseIdentifier)
        
    }
    
    

}
