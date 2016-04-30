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
    
    // MARK: - Class Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var prevSelectedIndexPath: NSIndexPath? = nil
    private var selectedIndexPath: NSIndexPath? {
        willSet {
            prevSelectedIndexPath = selectedIndexPath
        }
    }
    private var indexPathsToUpdate = [NSIndexPath] ()
    
    // Identifiers for nib files
    private struct TableViewCellIdentifiers {
        static let briefCellIdentifier = "GlossaryItemBriefTableViewCell"
        static let nothingFoundCellIdentifier = "NothingFoundTableViewCell"
        static let detailedCellIdentifier = "GlossaryItemDetailedTableViewCell"
    }
    
    // Data preparation
    var managedObjectContext: NSManagedObjectContext!
    private var fetchedResultsController: NSFetchedResultsController!
    private var searchFetchedResultsController: NSFetchedResultsController!

    private var entityName = "GlossaryItem"
//    private var glossary:[GlossaryItem] = []
//    private var searchResults:[GlossaryItem] = []
    private var hasSearched = false
    private var glossaryCount:Int = 0
    private var searchCount:Int = 0
    
    // MARK: - Class Settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAppearance()
        prepareTableView()
        loadNibFiles()
        performFetch()
    }
    
    func customizeAppearance() {
        // Configure search bar
        searchBar.barTintColor = UIColor.whiteColor()
        //        searchBar.tintColor = UIColor.whiteColor()
        
        searchBar.tintColor = UIColor(colorLiteralRed: 255/255 , green: 80/255 , blue: 100/255 , alpha: 1)
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKindOfClass(UITextField) {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor(colorLiteralRed: 230/255 , green: 230/255 , blue: 230/255 , alpha: 1)
                }
            }
        }
    }
    
    func prepareTableView() {
        tableView.contentInset.top = 64
        tableView.contentInset.bottom = 66
    }
    
    func loadNibFiles() {
        var cellNib = UINib(nibName: TableViewCellIdentifiers.briefCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.briefCellIdentifier)
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCellIdentifier)
        cellNib = UINib(nibName: TableViewCellIdentifiers.detailedCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.detailedCellIdentifier)
    }
    
    func performFetch() {
        if let moc = managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let sortDescriptor = NSSortDescriptor(key: "term", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "glossaryItemCache")
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
            } catch {
                fatalError("Failed to initialize FetchedResultsController: \(error)")
            }
            
            let countFetchRequest = NSFetchRequest(entityName: entityName)
            countFetchRequest.resultType = .CountResultType
            
            do {
                let results =
                    try managedObjectContext.executeFetchRequest(countFetchRequest) as! [NSNumber]
                let count = results.first!.integerValue
                glossaryCount = count
                print("The glossaryCount = \(glossaryCount)")
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            
//            do {
//                glossary = try moc.executeFetchRequest(fetchRequest) as! [GlossaryItem]
//            } catch {
//                print("Failed to retrieve record")
//                print(error)
//            }
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
        selectedIndexPath = nil
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
        selectedIndexPath = nil
        
        if searchBar.text == "" {
            hasSearched = false
        } else {
            hasSearched = true
        }
        
        performFetchSearchResult()
        
//        searchResults = [GlossaryItem]()
        
//        if let searchText = searchBar.text {
//            filterContentForSearchText(searchText)
//            tableView.reloadData()
//        }
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
//    func filterContentForSearchText(searchText: String) {
//        searchResults = glossary.filter({(glossaryItem:GlossaryItem) -> Bool in
//            let nameMatch = glossaryItem.term.rangeOfString(searchText, options:NSStringCompareOptions.CaseInsensitiveSearch)
//            return nameMatch != nil
//        })
//    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    func performFetchSearchResult() {
        let searchFetchRequest = NSFetchRequest(entityName: entityName)
        let searchPredicate = NSPredicate(format: "term LIKE %@", "moderato")
        let sortDescriptor = NSSortDescriptor(key: "term", ascending: true)
        searchFetchRequest.sortDescriptors = [sortDescriptor]
        searchFetchRequest.predicate = searchPredicate
        
        searchFetchedResultsController = NSFetchedResultsController(fetchRequest: searchFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: "searchGlossaryItemCache")
        searchFetchedResultsController.delegate = self
        
        do {
            try searchFetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        
        let countFetchRequest = NSFetchRequest(entityName: entityName)
        countFetchRequest.resultType = .CountResultType
        countFetchRequest.predicate = searchPredicate
        
        do {
            let results =
            try managedObjectContext.executeFetchRequest(countFetchRequest) as! [NSNumber]
            let count = results.first!.integerValue
            searchCount = count
            print("*** searchCount = \(searchCount)")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}

// MARK: - UITableViewDataSourceDelegate
extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasSearched {
            if searchCount == 0 {
                return 1
            } else {
                return searchCount
            }
        } else {
            return glossaryCount
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let defaultRowHeight:CGFloat = 56.5
        
        if hasSearched && searchCount == 0 {
            // for NoResultFoundCell
            return 88
        } else if let path = selectedIndexPath {
            if indexPath.compare(path) == NSComparisonResult.OrderedSame {
                // for DetailedCell
                tableView.estimatedRowHeight = defaultRowHeight
                return UITableViewAutomaticDimension
            } else {
                return defaultRowHeight
            }
        } else {
            return defaultRowHeight
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var itemContent: GlossaryItem
        
        if hasSearched {
            itemContent = searchFetchedResultsController.objectAtIndexPath(indexPath) as! GlossaryItem
            print("*** The indexPath is: \(indexPath)")
            print("*** The itemContent is: \(itemContent)")
        } else {
            itemContent = fetchedResultsController.objectAtIndexPath(indexPath) as! GlossaryItem
        }
        
        if let path = selectedIndexPath {
            if indexPath.compare(path) == NSComparisonResult.OrderedSame {
                cellIdentifier = TableViewCellIdentifiers.detailedCellIdentifier
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GlossaryItemDetailedTableViewCell
                
                cell.delegate = self
                cell.indexPath = indexPath
                cell.configureForItem(itemContent)
                return cell
            } else {
                // SITUATION I
                cellIdentifier = TableViewCellIdentifiers.briefCellIdentifier
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GlossaryItemBriefTableViewCell
                cell.termLabel.text = itemContent.term
                return cell
            }
        } else {
            // SITUATION II
            // The SITUATION I & II are same. Still couldn't find a good way to avoid this repeat.
            cellIdentifier = TableViewCellIdentifiers.briefCellIdentifier
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GlossaryItemBriefTableViewCell
            cell.termLabel.text = itemContent.term
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexPathsToUpdate.removeAll(keepCapacity: false)
        
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
            indexPathsToUpdate.append(indexPath)
        }
        
        if prevSelectedIndexPath != nil {
            indexPathsToUpdate.append(prevSelectedIndexPath!)
        }
        
//        tableView.reloadData()
        tableView.reloadRowsAtIndexPaths(indexPathsToUpdate, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}

// MARK: - CellDelegate
extension SearchViewController: InCellFunctionalityDelegate {
    func inCellButtonIsPressed(cell: GlossaryItemDetailedTableViewCell) {
        let indexPath = cell.indexPath
        var pressedItem: GlossaryItem!
        
        if hasSearched {
            pressedItem = searchFetchedResultsController.objectAtIndexPath(indexPath) as! GlossaryItem
        } else {
            pressedItem = fetchedResultsController.objectAtIndexPath(indexPath) as! GlossaryItem
        }
        
        var markSign: Bool {
            get {
                return pressedItem.isMarked.boolValue
            }
            set(value) {
                pressedItem.isMarked = value
                pressedItem.markedDate = NSDate()
            }
        }
        
        markSign = !markSign
        markSign ? cell.setStarState(.highlighted) : cell.setStarState(.normal)
        
        saveData()
    }
    
    func saveData() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension SearchViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        
        //-------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //-------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        case .Update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            guard selectedIndexPath != indexPath else {
                if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? GlossaryItemDetailedTableViewCell {
                    let item = controller.objectAtIndexPath(indexPath!) as! GlossaryItem
                    cell.configureForItem(item)
                }
                break
            }

        case .Move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
    
}

