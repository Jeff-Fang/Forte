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
        
        // Configure search bar
        
        // Configure table view
        tableView.contentInset.top = 64
        tableView.contentInset.bottom = 66
        
        // Load nib files
        var cellNib = UINib(nibName: TableViewCellIdentifiers.briefCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.briefCellIdentifier)
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCellIdentifier)
        cellNib = UINib(nibName: TableViewCellIdentifiers.detailedCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.detailedCellIdentifier)
        
        // Load glossary items from database
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

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        selectedIndexPath = NSIndexPath(forRow: 0, inSection: -1)
        tableView.reloadData()
        return true
    }
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        selectedIndexPath = NSIndexPath(forRow: 0, inSection: -1)
//        tableView.reloadData()
//    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        hasSearched = false
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        selectedIndexPath = NSIndexPath(forRow: 0, inSection: -1)
        
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
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

// MARK: - UITableViewDataSource

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
        let defaultRowHeight:CGFloat = 50
        
        if hasSearched && searchResults.count == 0 {
            // for NoResultFoundCell
            return 88
        } else if indexPath.compare(selectedIndexPath) == NSComparisonResult.OrderedSame {
            // for DetailedCell
            tableView.estimatedRowHeight = defaultRowHeight
            return UITableViewAutomaticDimension
        } else {
            return defaultRowHeight
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var dataSource = [GlossaryItem]()
        var cellIdentifier: String
        
        if hasSearched {
            dataSource = searchResults
        } else {
            dataSource = glossary
        }
        
        func configureInfoForDetailedCell(cell:GlossaryItemDetailedTableViewCell) {
            cell.termLabel.text = dataSource[indexPath.row].term
            cell.meaningLabel.text = dataSource[indexPath.row].meaning
            
            cell.indexPath = indexPath
            cell.delegate = self
            
            if let temp = dataSource[indexPath.row].isMarked {
                let starIsYellow = temp.boolValue
                print("*** starIsYellow is now \(starIsYellow)")
                
                starIsYellow ? cell.setStarState(.yellow) : cell.setStarState(.grey)
            }
        }
        
        guard dataSource.count != 0 else {
            cellIdentifier = TableViewCellIdentifiers.nothingFoundCellIdentifier
            let nothingFoundCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NothingFoundTableViewCell
            return nothingFoundCell
        }
        
        if indexPath.compare(selectedIndexPath) == NSComparisonResult.OrderedSame {
            cellIdentifier = TableViewCellIdentifiers.detailedCellIdentifier
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GlossaryItemDetailedTableViewCell
            configureInfoForDetailedCell(cell)
            return cell
            
        } else {
            cellIdentifier = TableViewCellIdentifiers.briefCellIdentifier
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GlossaryItemBriefTableViewCell
            cell.termLabel.text = dataSource[indexPath.row].term
            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedIndexPath != indexPath {
            selectedIndexPath = indexPath
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.endUpdates()
        } else {
            selectedIndexPath = NSIndexPath(forRow: 0, inSection: -1)
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

extension SearchViewController: InCellFunctionalityDelegate {
    func inCellButtonIsPressed(cell: GlossaryItemDetailedTableViewCell) {
        print("^^^ InCellButtonIsPressed!")
        let indexPath = cell.indexPath
        var glossaryItem: GlossaryItem = glossary[indexPath.row]
        
        if hasSearched {
            let searchedItem = searchResults[indexPath.row]
            for item in glossary {
                if item == searchedItem {
                    glossaryItem = item
                }
            }
            
        } else {
            glossaryItem = glossary[indexPath.row]
        }
        
        var markSign: Bool {
            get {
                return glossaryItem.isMarked.boolValue
            }
            set(value) {
                glossaryItem.isMarked = value
            }
        }
        
        markSign = !markSign
        
        if markSign {
            print("*** markSign is now True")
            cell.setStarState(.yellow)
        } else {
            print("*** markSign is now False")
            cell.setStarState(.grey)
        }
        
        configureMarkSignForCell()
    }
    
    func configureMarkSignForCell() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
        
    }
}
