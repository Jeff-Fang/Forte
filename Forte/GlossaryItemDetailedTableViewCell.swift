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

enum starState {
    case normal, highlighted
    func image() -> UIImage {
        switch self {
        case .normal :
            return UIImage(named: "Heart_grey")!
        case .highlighted :
            return UIImage(named: "Heart_red")!
        }
    }
}

class GlossaryItemDetailedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var starIconOutlet: UIButton!
    @IBOutlet weak var originLabel: UILabel!
    
    var delegate: InCellFunctionalityDelegate?
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
    
    func configureForItem(item: GlossaryItem) {
        if item.term.isEmpty {
            termLabel.text = "(No Term)"
        } else {
            termLabel.text = item.term
        }
        
        if let origin = item.origin {
            if origin.isEmpty {
                originLabel.text = ""
            } else {
                originLabel.text = item.origin
            }
        }
        
        if item.meaning.isEmpty {
            meaningLabel.text = "(No Meaning)"
        } else {
            meaningLabel.text = item.meaning
        }
        
        if let temp = item.isMarked {
            let starIsHighlighted = temp.boolValue
            starIsHighlighted ? setStarState(.highlighted) : setStarState(.normal)
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
