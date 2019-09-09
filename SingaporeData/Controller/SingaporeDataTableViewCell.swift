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
    @IBOutlet weak var clickableImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clickableImage.image = UIImage(named: "decrease")
        clickableImage.isUserInteractionEnabled = true
        clickableImage.contentMode = .scaleToFill
    }

    func configure(yearString: String, consumptionText: String, isClickble: Bool){
        self.year?.text = yearString
        self.consumption?.text = consumptionText
        clickableImage.isHidden = !isClickble
    }
}
