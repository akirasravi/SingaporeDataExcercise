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
        
        XCTAssertNotNil(viewController?.view,
                        "Controller should have a view")
        
        XCTAssertNotNil(viewController?.singaporeDataTableView,
                        "Controller should have a tableview")
                
        XCTAssertEqual(viewController?.viewModel.processedSingaporeData.count, 2,
                       "DataSource should have correct number of years")
   
        
        let expandCell =  SingaporeDataExpandedCell()
        expandCell.configure(yearString: "test", consumptionText: "test2")
        
        XCTAssertEqual("test", expandCell.quarter?.text)
        XCTAssertEqual("test2", expandCell.consumption?.text)

        let tableView = UITableView()
        tableView.register(SingaporeDataTableViewCell.self,
                           forCellReuseIdentifier: "singaporeDataCell")
        tableView.register(SingaporeDataTableViewCell.self,
                           forCellReuseIdentifier: "singaporeDataExpandedCell")
        tableView.dataSource = viewController.self
        tableView.delegate = viewController.self
        tableView.reloadData()
       
        XCTAssertEqual(viewController?.tableView(tableView, numberOfRowsInSection: 0), 2)
        
        XCTAssertEqual(viewController?.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0)), 48)
        
        let cell = viewController?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell)
        
        viewController?.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        viewController?.reloadData()
        let cell2 = viewController?.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        
        XCTAssertNotNil(cell2)
       
    }
}
