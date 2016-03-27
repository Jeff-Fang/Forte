//
//  AllGlossaryTableViewCell.swift
//  Forte
//
//  Created by Jeff Fang on 3/27/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

class AllGlossaryTableViewCell: UITableViewCell {

    @IBOutlet var termLabel: UILabel!
    @IBOutlet var meaningLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
