//
//  ServiceUtil.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import Foundation

protocol ServiceUtilProtocol {
     func getSingaporeDataFromAPI(completion: @escaping ([SingaporeDataResponse]?, String?) -> Void)
}

class ServiceUtil: ServiceUtilProtocol {
    static let shared = ServiceUtil()
    private init() {
        
    }
    
    func getSingaporeDataFromAPI(completion: @escaping ([SingaporeDataResponse]?, String?) -> Void){
        let endpointUrl: String = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        guard let url = URL(string: endpointUrl) else {
            completion(nil, "Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                completion(nil, "")
                return
            }
            guard let responseData = data else {
                completion(nil, "Internal server error")
                return
            }
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    if let result = jsonData["result"] as? [String:Any] {
                        if let records = result["records"] as? [[String:Any]] {
                            print(records)
                            do {
                                let json = try JSONSerialization.data(withJSONObject: records)
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                                let decodedCountries = try decoder.decode([SingaporeDataResponse].self, from: json)
                                completion(decodedCountries, nil)
                            } catch {
                               completion(nil, "error trying to convert data to JSON")
                            }
                         
                        }
                    }
                }
              
            } catch  {
                completion(nil, "error trying to convert data to JSON")
            }
        }
        task.resume()
    }
}
