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
        viewModel = nil
        super.tearDown()
    }

    func testGetTotalConsumption() {
        //given
        let array = ["0.3", "0.6"]
        XCTAssertEqual("0.9", viewModel?.getTotalConsumption(array: array))
    }
    
    func testExpandCollapseRow()
    {
        viewModel?.getSingaporeDataFromnService()
        viewModel?.expandCollapseRow(index: 0)
        XCTAssertEqual(4, viewModel?.processedSingaporeData.count)
    }
    func testGetSingaporeDataFromnService() {
        viewModel?.getSingaporeDataFromnService()
        XCTAssertEqual(2, viewModel?.processedSingaporeData.count)
    }
    
    func testfYearDemonstratesDecreaseInVolumeData() {
        //given
        let array1 = ["0.3", "0.6", "0.5", "0.9"]
        XCTAssertTrue(viewModel?.checkIfYearDemonstratesDecreaseInVolumeData(yearData: array1) ?? true)
        
        //given
        let array2 = ["0.3", "0.6", "0.7", "0.9"]
        XCTAssertFalse(viewModel?.checkIfYearDemonstratesDecreaseInVolumeData(yearData: array2) ?? false)
    }
    
    func testServiceFailure() {
        viewModel?.service = ServiceUtilErrorMock()
        viewModel?.getSingaporeDataFromnService()
        XCTAssertEqual(0, viewModel?.processedSingaporeData.count)
    }
    
    func testSaveSingaporeDatatoCache() {
        viewModel?.deleteDataFromCache()
        let mockData = [SingaporeDataResponse(volumeOfMobileData: "0.899", quarter: "2011-Q1"), SingaporeDataResponse(volumeOfMobileData: "0.1", quarter: "2011-Q2"), SingaporeDataResponse(volumeOfMobileData: "0.7", quarter: "2018-Q1")]
        
        viewModel?.saveSingaporeDatatoCache(data: mockData)
        if let retrievedData = viewModel?.retrieveDataFromCache() {
            XCTAssertEqual(3, retrievedData.count)
        }

    }

}

class ServiceUtilMock: ServiceUtilProtocol {
    func getSingaporeDataFromAPI(completion: @escaping ([SingaporeDataResponse]?, String?) -> Void) {
        let mockData = [SingaporeDataResponse(volumeOfMobileData: "0.899", quarter: "2011-Q1"), SingaporeDataResponse(volumeOfMobileData: "0.1", quarter: "2011-Q2"), SingaporeDataResponse(volumeOfMobileData: "0.7", quarter: "2018-Q1")]
        
        completion(mockData, nil)
    }
    
}

class ServiceUtilErrorMock: ServiceUtilProtocol{
    func getSingaporeDataFromAPI(completion: @escaping ([SingaporeDataResponse]?, String?) -> Void) {
        completion(nil, "serviceError")
    }
    
}

