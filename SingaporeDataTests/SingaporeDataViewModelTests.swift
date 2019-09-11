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
    var reloadDataWasCalled: Bool = false
    var showAlertWasCalled: Bool = false
    var insertRowsWasCalled: Bool = false
    var deleteRowsWasCalled: Bool = false
    var beginUpdatesWasCalled: Bool = false
    var endUpdatesWasCalled: Bool = false

    override func setUp() {
        reloadDataWasCalled = false
        showAlertWasCalled = false
        insertRowsWasCalled = false
        deleteRowsWasCalled = false
        beginUpdatesWasCalled = false
        endUpdatesWasCalled = false
        viewModel = SingaporeDataViewModel()
        viewModel?.service = ServiceUtilMock()
        viewModel?.delegate = self
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
        XCTAssertEqual(7, viewModel?.processedSingaporeData.count)
        XCTAssertTrue(insertRowsWasCalled)
        XCTAssertTrue(beginUpdatesWasCalled)
        XCTAssertTrue(endUpdatesWasCalled)

    }
    
    func testCheck() {
        XCTAssertEqual(viewModel?.checkAndGiveNewIdexOfImage(index: 0), 0)
    }
    
    func testGetYearDataAndShow() {
        viewModel?.getYearDataAndShow(dataRow: SingaporeDataModel(isExpandable: true, isExpanded: false, header: "2009", consumption: "17", quarterlyData: []))
        XCTAssertTrue(showAlertWasCalled)
    }
    
    func testGetSingaporeDataFromnService() {
        viewModel?.getSingaporeDataFromnService()
        XCTAssertEqual(3, viewModel?.processedSingaporeData.count)
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

extension SingaporeDataViewModelTests: SingaporeDataViewControllerDelegate {
    func insertRows(index: Int, count: Int) {
        insertRowsWasCalled = true
    }
    
    func deleteRows(index: Int, count: Int) {
        deleteRowsWasCalled = true
    }
    
    func beginUpdates() {
        beginUpdatesWasCalled = true
    }
    
    func endUpdates() {
        endUpdatesWasCalled = true
    }
    
    func reloadData() {
        reloadDataWasCalled = true
    }
    
    func showAlert(title: String, message: String) {
        showAlertWasCalled = true
    }
}

class ServiceUtilMock: ServiceUtilProtocol {
    func getSingaporeDataFromAPI(completion: @escaping ([SingaporeDataResponse]?, String?) -> Void) {
        let mockData = [
            SingaporeDataResponse(volumeOfMobileData: "0.899", quarter: "2011-Q1"),
            SingaporeDataResponse(volumeOfMobileData: "0.1", quarter: "2011-Q2"),
            SingaporeDataResponse(volumeOfMobileData: "0.899", quarter: "2011-Q4"),
            SingaporeDataResponse(volumeOfMobileData: "0.1", quarter: "2011-Q4"),
            SingaporeDataResponse(volumeOfMobileData: "0.899", quarter: "2012-Q1"),
            SingaporeDataResponse(volumeOfMobileData: "0.1", quarter: "2012-Q2"),
            SingaporeDataResponse(volumeOfMobileData: "0.7", quarter: "2013-Q1")]
        
        completion(mockData, nil)
    }
    
}

class ServiceUtilErrorMock: ServiceUtilProtocol{
    func getSingaporeDataFromAPI(completion: @escaping ([SingaporeDataResponse]?, String?) -> Void) {
        completion(nil, "serviceError")
    }
}

