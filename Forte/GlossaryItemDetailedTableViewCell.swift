//
//  GlossaryItemDetailedTableViewCell.swift
//  Forte
//
//  Created by Jeff Fang on 3/31/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

class GlossaryItemDetailedTableViewCell: UITableViewCell {
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var starIconOutlet: UIButton!
    
    @IBAction func starIcon(sender: UIButton) {
        print("Star Pressed!")
        toggleStar()
    }
    
    enum starState {
        case grey, yellow
        func image() -> UIImage {
            switch self {
            case .grey :
                return UIImage(named: "greyStar")!
            case .yellow :
                return UIImage(named: "yellowStar")!
            }
        }
    }
    
    var currentStarState : starState = .grey
    
    func toggleStar() {
        if currentStarState == .grey {
            starIconOutlet.setImage(starState.yellow.image(), forState: .Normal)
            currentStarState == .yellow
            print("turned Yellow")
        } else {
            starIconOutlet.setImage(starState.grey.image(), forState: .Normal)
            currentStarState == .grey
            print("turned grey")
        }
    }
    
    override func awakeFromNib() {
        currentStarState = .grey
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
