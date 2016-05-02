//
//  Preloader.swift
//  Forte
//
//  Created by Jeff Fang on 5/1/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import CoreData

class Preloader {
    let dataSourceName = "MusicTerms"
    var coreDataStack: CoreDataStack!

    func preloadData () {
        
        // Load the data file. For any reasons it can't be loaded, we just return
        guard let contentsOfURL = NSBundle.mainBundle().URLForResource(dataSourceName, withExtension: "csv") else {
            print("get contents URL failed! ")
            return
        }
        
        // Remove all the menu items before preloading
        removeData()
        
        if let items = Parser.parseCSV(contentsOfURL, encoding: NSUTF8StringEncoding) {
            loadItems(items)
        }
    }
    
    func loadItems(items: [ParseItem]) {
        for item in items {
            let glossaryItem = NSEntityDescription.insertNewObjectForEntityForName("GlossaryItem", inManagedObjectContext: coreDataStack.managedObjectContext) as! GlossaryItem
            glossaryItem.term = item.term
            glossaryItem.meaning = item.meaning
            glossaryItem.isMarked = false
            glossaryItem.note = ""
            glossaryItem.origin = item.origin
            
            do {
                try coreDataStack.managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func removeData () {
        // Remove the existing items
        let fetchRequest = NSFetchRequest(entityName: "GlossaryItem")
        
        do {
            let menuItems = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as! [GlossaryItem]
            for menuItem in menuItems {
                coreDataStack.managedObjectContext.deleteObject(menuItem)
            }
        } catch {
            print(error)
        }
    }
}