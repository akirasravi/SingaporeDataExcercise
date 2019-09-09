//
//  SingaporeDAta.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import Foundation

struct SingaporeDataResponse: Codable {
    let volumeOfMobileData: String
    let quarter : String

    init(volumeOfMobileData: String, quarter: String) {
        self.volumeOfMobileData = volumeOfMobileData
        self.quarter = quarter
    }
}


