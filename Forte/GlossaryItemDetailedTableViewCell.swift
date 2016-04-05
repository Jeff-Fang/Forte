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
    
    let currentStarState = UserData()
    
    func toggleStar() {
        if currentStarState.currentStarState == .grey {
            starIconOutlet.setImage(UserData.starState.yellow.image(), forState: .Normal)
            currentStarState.currentStarState == .yellow
            print("turned Yellow")
        } else {
            starIconOutlet.setImage(UserData.starState.grey.image(), forState: .Normal)
            currentStarState.currentStarState == .grey
            print("turned grey")
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
