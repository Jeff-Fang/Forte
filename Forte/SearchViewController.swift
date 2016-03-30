//
//  SearchViewController.swift
//  Forte
//
//  Created by Jeff Fang on 3/30/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var briefCellIdentifier = "GlossaryItemBriefTableViewCell"
    
    var glossary:[GlossaryItem] = []
    
    var searchResults:[GlossaryItem] = []
    var hasSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset.top = 64
        tableView.contentInset.bottom = 66
        tableView.rowHeight = 66
        
        let briefCellNib = UINib(nibName: briefCellIdentifier, bundle: nil)
        tableView.registerNib(briefCellNib, forCellReuseIdentifier: briefCellIdentifier)
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            hasSearched = false
        } else {
            hasSearched = true
        }
        
        searchResults = [GlossaryItem]()
        
        if let searchText = searchBar.text {
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
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasSearched {
            return searchResults.count
        } else {
            return glossary.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(briefCellIdentifier, forIndexPath: indexPath) as! GlossaryItemBriefTableViewCell
        
        if hasSearched {
            cell.termLabel.text = searchResults[indexPath.row].term
            cell.meaningLabel.text = searchResults[indexPath.row].meaning
        } else {
            cell.termLabel.text = glossary[indexPath.row].term
            cell.meaningLabel.text = glossary[indexPath.row].meaning
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
