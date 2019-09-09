//
//  SingaporeDataTableViewCell.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import UIKit

class SingaporeDataTableViewCell: UITableViewCell {
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var consumption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configure(yearString: String, consumptionText: String){
        self.year?.text = yearString
        self.consumption?.text = consumptionText
    }
}
