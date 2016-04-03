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
    
    // Identifiers for nib files
    struct TableViewCellIdentifiers {
        static let briefCellIdentifier = "GlossaryItemBriefTableViewCell"
        static let nothingFoundCellIdentifier = "NothingFoundTableViewCell"
        static let detailedCellIdentifier = "GlossaryItemDetailedTableViewCell"
    }
    
    var glossary:[GlossaryItem] = []
    
    var searchResults:[GlossaryItem] = []
    var hasSearched = false
    
    var selectedIndexPath = NSIndexPath(forRow: 0, inSection: -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset.top = 64
        tableView.contentInset.bottom = 66
//        tableView.estimatedRowHeight = 66
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Load nib files
        var cellNib = UINib(nibName: TableViewCellIdentifiers.briefCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.briefCellIdentifier)
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCellIdentifier)
        cellNib = UINib(nibName: TableViewCellIdentifiers.detailedCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.detailedCellIdentifier)
        
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
            filterContentForSearchText(searchText)
            print("searchResults.count = \(searchResults.count)")
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
            if searchResults.count == 0 {
                return 1
            } else {
                return searchResults.count
            }
        } else {
            return glossary.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.compare(selectedIndexPath) == NSComparisonResult.OrderedSame {
            tableView.estimatedRowHeight = 37
            return UITableViewAutomaticDimension
        } else {
            if hasSearched {
                if searchResults.count == 0 {
                    return 88
                } else {
                    tableView.estimatedRowHeight = 37
                    return UITableViewAutomaticDimension
                }
            } else {
                tableView.estimatedRowHeight = 37
                return UITableViewAutomaticDimension
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.compare(selectedIndexPath) == NSComparisonResult.OrderedSame {
            let detailedCell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.detailedCellIdentifier, forIndexPath: indexPath) as! GlossaryItemDetailedTableViewCell
            detailedCell.termLabel.text = glossary[indexPath.row].term
            detailedCell.meaningLabel.text = glossary[indexPath.row].meaning
            return detailedCell
        } else {
            if hasSearched {
                if hasSearched && searchResults.count == 0 {
                    let nothingFoundCell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCellIdentifier, forIndexPath: indexPath) as! NothingFoundTableViewCell
                    return nothingFoundCell
                } else {
                    let briefCell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.briefCellIdentifier, forIndexPath: indexPath) as! GlossaryItemBriefTableViewCell
                    briefCell.termLabel.text = searchResults[indexPath.row].term
                    return briefCell
                }
            } else {
                let briefCell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.briefCellIdentifier, forIndexPath: indexPath) as! GlossaryItemBriefTableViewCell
                briefCell.termLabel.text = glossary[indexPath.row].term
                return briefCell
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
