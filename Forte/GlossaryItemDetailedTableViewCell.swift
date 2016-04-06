//
//  GlossaryItemDetailedTableViewCell.swift
//  Forte
//
//  Created by Jeff Fang on 3/31/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

class GlossaryItemDetailedTableViewCell: UITableViewCell, SearchViewItemCellController {
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var starIconOutlet: UIButton!
    
    @IBAction func starIcon(sender: UIButton) {
        print("Star Pressed!")
    }
    
    func setStarState(state: starState) {
        switch state{
        case .yellow:
            print("**** case .yellow!")
            starIconOutlet.setImage(starState.yellow.image(), forState: .Normal)
        case .grey:
            print("**** case .grey!")
            starIconOutlet.setImage(starState.grey.image(), forState: .Normal)
        }
    }

    
    
//    var currentStarState : starState = .grey
    
//    func findIfStared() {
//        print("*** findIfStared!")
//        if let isMarked: Bool = detailedCellInfo?.itermIsMarked {
//            print("*** Protocol Correct!")
//            if isMarked {
//                currentStarState = .yellow
//            } else {
//                currentStarState = .grey
//            }
//        } else {
//            print("*** Error Protocol!")
//        }
//    }
    
//    func toggleStar() {
//        if currentStarState == .grey {
//            starIconOutlet.setImage(starState.yellow.image(), forState: .Normal)
//            currentStarState == .yellow
//            print("turned Yellow")
//        } else {
//            starIconOutlet.setImage(starState.grey.image(), forState: .Normal)
//            currentStarState == .grey
//            print("turned grey")
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
