//
//  SingaporeDataViewModel.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import Foundation

protocol SingaporeDataViewModelProtocol{
    var singaporeDataTableData: [SingaporeData] {get set}
    var delegate: SingaporeDataViewControllerDelegate? {get set}
    var processedSingaporeData: [(key: String, value: [String])] {get set}
    var service: ServiceUtilProtocol {get set}
    func getTotalConsumption(array:  [String]) -> String 
    func getSingaporeDataFromnService()
}

class SingaporeDataViewModel: SingaporeDataViewModelProtocol{
    
    weak var delegate: SingaporeDataViewControllerDelegate?
    var service: ServiceUtilProtocol = ServiceUtil.shared
    var singaporeDataTableData: [SingaporeData] = []
    var processedSingaporeData: [(key: String, value: [String])] = []
    
    func getSingaporeDataFromnService(){
        
        self.service.getSingaporeDataFromAPI(url: "") { (data) in
            if let singaporeData = data {
                var dictionary:[String: [String]] = [:]
                
                for data in singaporeData {
                    let quarters = data.quarter.split(separator: "-")
                    let year = String(quarters[0])
                    if var value = dictionary[year], value.count > 0 {
                        value.append(data.volumeOfMobileData)
                        dictionary.updateValue(value, forKey: year)
                    }else{
                        dictionary[year] = [data.volumeOfMobileData]
                    }
                }
                
                let sortedDictionary = dictionary.sorted{$0.key < $1.key }

                self.processedSingaporeData = sortedDictionary
                
                print(sortedDictionary)
                self.delegate?.reloadData()
            }else{
               self.singaporeDataTableData = []
            }
        }
    }
    
    
    func getTotalConsumption(array:  [String]) -> String {
        
        var total: NSDecimalNumber = 0.0
        
        for value in array {
            let valueDouble = NSDecimalNumber(string: value)
            total = valueDouble.adding(total)
        }
        
        return String(describing: total)
    }
    
}
