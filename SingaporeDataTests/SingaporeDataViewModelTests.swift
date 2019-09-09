//
//  SingaporeDataTests.swift
//  SingaporeDataTests
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import XCTest
@testable import SingaporeData

class SingaporeDataViewModelTests: XCTestCase {
    var viewModel: SingaporeDataViewModel?
    override func setUp() {
        viewModel = SingaporeDataViewModel()
        viewModel?.service = ServiceUtilMock()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetTotalConsumption() {
        XCTAssertEqual("0.9", viewModel?.getTotalConsumption(array: ["0.3", "0.6"]))
    }
    
    
    func testGetSingaporeDataFromnService() {
        viewModel?.getSingaporeDataFromnService()
        XCTAssertEqual(2, viewModel?.processedSingaporeData.count)
    }

}

class ServiceUtilMock: ServiceUtilProtocol{
    func getSingaporeDataFromAPI(url: String, completion: @escaping ([SingaporeDataResponse]?) -> Void) {
        
        let mockData = [SingaporeDataResponse(volumeOfMobileData: "0.899", quarter: "2019-Q1"), SingaporeDataResponse(volumeOfMobileData: "0.1", quarter: "2019-Q2"), SingaporeDataResponse(volumeOfMobileData: "0.7", quarter: "2018-Q1")]
        completion(mockData)
    }
    
}

