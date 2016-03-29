//
//  AllGlossaryTableViewController.swift
//  Forte
//
//  Created by Jeff Fang on 3/27/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import CoreData

class AllGlossaryTableViewController: UITableViewController {

//    var glossary:[GlossaryItem] = [
//        GlossaryItem(term: "Forte", meaning: "Strong (i.e. to be played or sung loudly)"),
//        GlossaryItem(term: "Piano", meaning: "Gently (i.e. played or sung softly) (see dynamics)"),
//        GlossaryItem(term: "più", meaning: "More; see mosso")
//    ]
    
    var glossary:[GlossaryItem] = []
    var fetchResultController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load menu items from database
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "GlossaryItem")
            do {
                glossary = try managedObjectContext.executeFetchRequest(fetchRequest) as! [GlossaryItem]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        // Enable self sizing cells
        // tableView.estimatedRowHeight = 66.0
        // tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return glossary.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath) as! AllGlossaryTableViewCell
        
        // Configure the cell
        cell.termLabel.text = glossary[indexPath.row].term
        cell.meaningLabel.text = glossary[indexPath.row].meaning
        
        return cell
    }
}
