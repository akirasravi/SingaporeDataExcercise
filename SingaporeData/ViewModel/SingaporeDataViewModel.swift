//
//  SingaporeDataViewModel.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import Foundation
import CoreData
import UIKit
protocol SingaporeDataViewModelProtocol {
    
    var delegate: SingaporeDataViewControllerDelegate? {get set}
    var processedSingaporeData: [SingaporeDataForTable]  {get set}
    var service: ServiceUtilProtocol {get set}
    func getTotalConsumption(array:  [String]) -> String
    func getYearDataAndShow(dataRow: SingaporeDataForTable)
    func expandCollapseRow(index: Int)
    func getSingaporeDataFromnService()
    func checkIfYearDemonstratesDecreaseInVolumeData(yearData: [String]) -> Bool
}

class SingaporeDataViewModel: SingaporeDataViewModelProtocol{
    
    weak var delegate: SingaporeDataViewControllerDelegate?
    var service: ServiceUtilProtocol = ServiceUtil.shared
    var processedSingaporeData: [SingaporeDataForTable] = []
    
    func getSingaporeDataFromnService() {
        
        self.service.getSingaporeDataFromAPI() { (data, error) in
            if let singaporeData = data {
               
                DispatchQueue.main.async {
                    self.saveSingaporeDatatoCache(data: singaporeData)
                }
                
                self.reloadTableWithNewContent(singaporeData: singaporeData)
            }else{
                //if API failed fetch data from cache
                DispatchQueue.main.async {
                    let dataFromCache = self.retrieveDataFromCache()
                    self.reloadTableWithNewContent(singaporeData: dataFromCache)
                }
                
                if let error = error {
                    self.delegate?.showAlert(title: "error", message: error)
                }else {
                    self.delegate?.showAlert(title: "error", message: "generic error")
                }
            }
        }
    }
    
    func reloadTableWithNewContent (singaporeData: [SingaporeDataResponse]) {
        var dictionary:[String: [String]] = [:]
        
        DispatchQueue.main.async {
            self.saveSingaporeDatatoCache(data: singaporeData)
        }
        
        for data in singaporeData {
            let quarters = data.quarter.split(separator: "-")
            let year = String(quarters[0])
            
            if year >= "2008" && year < "2019"
            {
                if var value = dictionary[year], value.count > 0 {
                    value.append(data.volumeOfMobileData)
                    dictionary.updateValue(value, forKey: year)
                }else{
                    dictionary[year] = [data.volumeOfMobileData]
                }
            }
            
        }
        
        let sortedDictionary = dictionary.sorted { $0.key < $1.key }
        
        var sortedObjectsArray: [SingaporeDataForTable] = []
        
        for record in sortedDictionary {
            let datarecord = SingaporeDataForTable(isExpandable: true, isExpanded: false, header: record.key, consumption: getTotalConsumption(array: record.value), quarterlyData: record.value)
            sortedObjectsArray.append(datarecord)
        }
        
        self.processedSingaporeData = sortedObjectsArray
        
        self.delegate?.reloadData()
    }
    
    func getTotalConsumption(array:  [String]) -> String {
        
        var total: NSDecimalNumber = 0.0
        
        for value in array {
            let valueDouble = NSDecimalNumber(string: value)
            total = valueDouble.adding(total)
        }
        
        return String(describing: total)
    }
    
    func checkIfYearDemonstratesDecreaseInVolumeData(yearData: [String]) -> Bool {
        var i: Int = 1
        
        while i < yearData.count {
            if yearData[i] < yearData[i-1] {
                return true
            }
            i += 1
        }
        
        return false
    }
    
    func getYearDataAndShow(dataRow: SingaporeDataForTable) {
        var i = 1
        var message = ""
        let string = "Q%d : %@\n"
        for value in dataRow.quarterlyData {
            message += String(format: string, i, value)
            i+=1
        }
        
        let title = String(format: "Year %@", dataRow.header)
        self.delegate?.showAlert(title: title, message: message)
    }
    
    func expandCollapseRow(index: Int) {
        let dataRow = self.processedSingaporeData[index]
        
        if dataRow.isExpanded {
            let left = index
            let right  = index + dataRow.quarterlyData.count
            self.processedSingaporeData.removeSubrange(left+1..<right+1)
            self.processedSingaporeData[index].isExpanded = false
            self.delegate?.reloadData()
        } else if dataRow.isExpandable {
            var records: [SingaporeDataForTable] = []
            var i = 1
            for record in dataRow.quarterlyData {
                let x = SingaporeDataForTable(isExpandable: false, isExpanded: false, header: String.init(format: "Q%d: ", i), consumption: record, quarterlyData: [])
                records.append(x)
                i+=1
            }
            self.processedSingaporeData[index].isExpanded = true
            
           // self.processedSingaporeData = self.processedSingaporeData.filter { $0.isExpandable == true }

            self.processedSingaporeData.insert(contentsOf: records, at: index+1)
            self.delegate?.reloadData()
        }
    }
    
    func saveSingaporeDatatoCache(data: [SingaporeDataResponse]) {
        
        deleteDataFromCache()
        
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let singaporeDataEntity = NSEntityDescription.entity(forEntityName: "ConsumptionData", in: managedContext) else{
            return
        }
        
        
        for singaporeDataRecord in data {
            let dataRecord = NSManagedObject(entity: singaporeDataEntity, insertInto: managedContext)
            dataRecord.setValue(singaporeDataRecord.quarter, forKey: "quarter")
            dataRecord.setValue(singaporeDataRecord.volumeOfMobileData, forKey: "volumeOfMobileData")
        }
        
        do {
            try managedContext.save()
        }  catch let error as NSError {
            print(error)
        }
        
    }
    
    func retrieveDataFromCache() -> [SingaporeDataResponse] {
        
        var singaporeDataFromCache: [SingaporeDataResponse] = []
        
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConsumptionData")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject]{
               
                if let quarter = data.value(forKey: "quarter") as? String {
                    if let consumption = data.value(forKey: "volumeOfMobileData") as? String {
                         let singaporeDatarecord = SingaporeDataResponse(volumeOfMobileData: consumption, quarter: quarter)
                        singaporeDataFromCache.append(singaporeDatarecord)
                    }
                }
            }
            
            return singaporeDataFromCache
        }
        catch let error as NSError {
            print(error)
        }
        return singaporeDataFromCache
    }
    
    
    func deleteDataFromCache() {
        
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConsumptionData")
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
            
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    
    
}
