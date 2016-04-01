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
    var briefCellIdentifier = "GlossaryItemBriefTableViewCell"
    var nothingFoundCellIdentifier = "NothingFoundTableViewCell"
    var detailedCellIdentifier = "GlossaryItemDetailedTableViewCell"
    
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
        let briefCellNib = UINib(nibName: briefCellIdentifier, bundle: nil)
        tableView.registerNib(briefCellNib, forCellReuseIdentifier: briefCellIdentifier)
        let nothingFoundCellNib = UINib(nibName: nothingFoundCellIdentifier, bundle: nil)
        tableView.registerNib(nothingFoundCellNib, forCellReuseIdentifier: nothingFoundCellIdentifier)
        let detailedCellNib = UINib(nibName: detailedCellIdentifier, bundle: nil)
        tableView.registerNib(detailedCellNib, forCellReuseIdentifier: detailedCellIdentifier)
        
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
//        if indexPath.compare(selectedIndexPath) == NSComparisonResult.OrderedSame {
//            return 120
//        } else {
//            if hasSearched {
//                if searchResults.count == 0 {
//                    return 66
//                } else {
//                    return UITableViewAutomaticDimension
//                }
//            } else {
//                return UITableViewAutomaticDimension
//            }
//        }
        
        tableView.estimatedRowHeight = 66
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let briefCell = tableView.dequeueReusableCellWithIdentifier(briefCellIdentifier, forIndexPath: indexPath) as! GlossaryItemBriefTableViewCell
        let nothingFoundCell = tableView.dequeueReusableCellWithIdentifier(nothingFoundCellIdentifier, forIndexPath: indexPath) as! NothingFoundTableViewCell
        let detailedCell = tableView.dequeueReusableCellWithIdentifier(detailedCellIdentifier, forIndexPath: indexPath) as! GlossaryItemDetailedTableViewCell
        
        if indexPath.compare(selectedIndexPath) == NSComparisonResult.OrderedSame {
            return detailedCell
        } else {
            if hasSearched {
                if searchResults.count > 0 {
                    briefCell.termLabel.text = searchResults[indexPath.row].term
                    briefCell.meaningLabel.text = searchResults[indexPath.row].meaning
                } else {
                    return nothingFoundCell
                }
            } else {
                briefCell.termLabel.text = glossary[indexPath.row].term
                briefCell.meaningLabel.text = glossary[indexPath.row].meaning
            }
            return briefCell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedIndexPath = indexPath
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
