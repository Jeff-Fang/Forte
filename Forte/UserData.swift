//
//  UserData.swift
//  Forte
//
//  Created by Jeff Fang on 4/6/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

class UserData: NSObject {
    
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
    
    var currentStarState : starState
    
    override init() {
        currentStarState = .grey
        super.init()
    }
}