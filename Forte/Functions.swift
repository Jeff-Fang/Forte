//
//  Functions.swift
//  Forte
//
//  Created by Jeff Fang on 4/6/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

enum starState {
    case normal, highlighted
    func image() -> UIImage {
        switch self {
        case .normal :
            return UIImage(named: "Heart_grey")!
        case .highlighted :
            return UIImage(named: "Heart_blue")!
        }
    }
    
}
