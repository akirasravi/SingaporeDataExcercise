//
//  singaporeDataExpandedCell.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 10/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import UIKit

class SingaporeDataExpandedCell: UITableViewCell {

    @IBOutlet weak var quarter: UILabel!
    @IBOutlet weak var consumption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(yearString: String, consumptionText: String){
        self.quarter?.text = yearString
        self.consumption?.text = consumptionText
    }

}
