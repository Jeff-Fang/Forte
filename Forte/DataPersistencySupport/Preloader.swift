//
//  Preloader.swift
//  Forte
//
//  Created by Jeff Fang on 5/1/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class Preloader {
    let dataSourceName = "MusicTerms"
    var coreDataStack: CoreDataStack!

    func preloadData () {
        print("Preloading!")
        // Load the data file. For any reasons it can't be loaded, we just return
        guard let contentsOfURL = Bundle.main.url(forResource:dataSourceName, withExtension: "csv") else {
            print("get contents URL failed! ")
            return
        }
        // Remove all the menu items before preloading
        removeData()
        
        if let items = Parser.parseCSV(contentsOfURL, encoding: String.Encoding.utf8) {
            loadItems(items)
        }
    }
    
    func loadItems(_ items: [ParseItem]) {
        let context = coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GlossaryItem", in: context)
        for item in items {
            let glossaryItem = NSManagedObject(entity: entity!, insertInto: context)
            glossaryItem.setValue(item.term, forKey: "term")
            glossaryItem.setValue(item.meaning, forKey: "meaning")
            glossaryItem.setValue(false, forKey: "isMarked")
            glossaryItem.setValue("", forKey: "note")
            glossaryItem.setValue(item.origin, forKey: "origin")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error)
            }
        }
    }
    
    func removeData () {
        // Remove the existing items
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GlossaryItem")
        
        do {
            let menuItems = try coreDataStack.persistentContainer.viewContext.fetch(fetchRequest) as! [GlossaryItem]
            for menuItem in menuItems {
                coreDataStack.persistentContainer.viewContext.delete(menuItem)
            }
        } catch {
            print(error)
        }
    }
}
