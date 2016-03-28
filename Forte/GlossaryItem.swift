//
//  GlossaryItem.swift
//  Forte
//
//  Created by Jeff Fang on 3/28/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import Foundation

class GlossaryItem {
    var term = ""
    var meaning = ""
    
    init(term:String, meaning:String) {
        self.term = term
        self.meaning = meaning 
    }
}