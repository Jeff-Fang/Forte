//
//  MarkedItemTableViewCell.swift
//  Forte
//
//  Created by Jeff Fang on 4/10/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

class MarkedItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var markedTermLabel: UILabel!
    @IBOutlet weak var markedMeaningLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}