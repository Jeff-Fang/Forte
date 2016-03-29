//
//  AllGlossaryTableViewController.swift
//  Forte
//
//  Created by Jeff Fang on 3/27/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import CoreData

class AllGlossaryTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var glossary:[GlossaryItem] = []
    
    var searchController:UISearchController!
    var searchResults:[GlossaryItem] = []
    
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
        
        // Configure the search bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
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
        if searchController.active {
            print("\(searchResults.count) items in searchResults")
            return searchResults.count
        } else {
            return glossary.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath) as! AllGlossaryTableViewCell
        let glossaryItem = (searchController.active) ? searchResults[indexPath.row] : glossary[indexPath.row]
        
        // Configure the cell
        cell.termLabel.text = glossaryItem.term
        cell.meaningLabel.text = glossaryItem.meaning
        
        return cell
    }
    
    // MARK: - UISearchResultsUpdating Protocal
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            print(searchText)
            print("searchResults.count = \(searchResults.count)")
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = glossary.filter({(glossaryItem:GlossaryItem) -> Bool in
            let nameMatch = glossaryItem.term!.rangeOfString(searchText, options:NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil
        })
    }
}
