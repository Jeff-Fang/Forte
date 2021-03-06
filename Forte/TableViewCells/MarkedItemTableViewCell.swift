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
    var origin: String?
    var markedItemNote: String?
    var cellIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForItem(_ item: GlossaryItem) {
        if item.term.isEmpty {
            markedTermLabel.text = "(No Term)"
        } else {
            markedTermLabel.text = item.term
        }
        
        if item.meaning.isEmpty {
            markedMeaningLabel.text = "(No Meaning)"
        } else {
            markedMeaningLabel.text = item.meaning
        }
        
        origin = item.origin
        markedItemNote = item.note
    }

}
