//
//  GlossaryItemDetailedTableViewCell.swift
//  Forte
//
//  Created by Jeff Fang on 3/31/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

protocol InCellFunctionalityDelegate {
    func inCellButtonIsPressed(cell: GlossaryItemDetailedTableViewCell)
}

class GlossaryItemDetailedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var starIconOutlet: UIButton!
    
    var delegate:InCellFunctionalityDelegate?
    var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: -1)
    
    @IBAction func starIcon(sender: UIButton) {
        delegate?.inCellButtonIsPressed(self)
    }
    
    func setStarState(state: starState) {
        switch state{
        case .highlighted:
            starIconOutlet.setImage(starState.highlighted.image(), forState: .Normal)
        case .normal:
            starIconOutlet.setImage(starState.normal.image(), forState: .Normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
