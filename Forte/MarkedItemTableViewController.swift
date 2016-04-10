//
//  MarkedItemTableViewController.swift
//  Forte
//
//  Created by Jeff Fang on 4/10/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import CoreData

class MarkedItemTableViewController: UITableViewController {
    
    var fetchRequest: NSFetchRequest!
    var markedItems:[GlossaryItem] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure tableView
        
        tableView.rowHeight = 80
        
        // Load markedItems from database
        
        let model = (UIApplication.sharedApplication().delegate as? AppDelegate)?.persistentStoreCoordinator.managedObjectModel
        fetchRequest = model!.fetchRequestTemplateForName("MarkedItem")
        
        do {
            markedItems = try (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext.executeFetchRequest(fetchRequest) as! [GlossaryItem]
            print("*** The data in markedItems:")
            print(markedItems)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return markedItems.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MarkedItemCell", forIndexPath: indexPath) as! MarkedItemTableViewCell
        let item = markedItems[indexPath.row]
        cell.markedTermLabel!.text = item.term
        cell.markedMeaningLabel!.text = item.meaning
        
        return cell
    }
}

