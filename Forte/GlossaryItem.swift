//
//  GlossaryItem.swift
//  Forte
//
//  Created by Jeff Fang on 3/28/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import Foundation
import CoreData

class GlossaryItem:NSManagedObject {
    @NSManaged var term:String?
    @NSManaged var meaning:String?
    @NSManaged var isMarked:NSNumber!
    @NSManaged var note:String?
}
