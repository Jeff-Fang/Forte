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
    
    // Identifiers for nib files
    private struct cellID {
        static let brief = "GlossaryItemBriefTableViewCell"
        static let nothingFound = "NothingFoundTableViewCell"
        static let detailed = "GlossaryItemDetailedTableViewCell"
    }
    
    // Data preparation
    var managedObjectContext: NSManagedObjectContext!
    private var fetchedResultsController: NSFetchedResultsController!
    private var searchFetchedResultsController: NSFetchedResultsController!

    private var entityName = "GlossaryItem"
    private var hasSearched = false
    private var glossaryCount: Int = 0
    private var searchCount: Int = 0
    
    private var indexPathsToUpdate = [NSIndexPath] ()
    private var prevSelectedIndexPath: NSIndexPath? = nil
    private var selectedIndexPath: NSIndexPath? {
        willSet {
            prevSelectedIndexPath = selectedIndexPath
        }
    }
    
    // MARK: - Class Settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAppearance()
        prepareTableView()
        loadNibFiles()
        performFetch()
        setGestureRecognizer()
        searchBar.becomeFirstResponder()
    }
    
    func customizeAppearance() {
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
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func loadNibFiles() {
        var cellNib = UINib(nibName: cellID.brief, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: cellID.brief)
        cellNib = UINib(nibName: cellID.nothingFound, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: cellID.nothingFound)
        cellNib = UINib(nibName: cellID.detailed, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: cellID.detailed)
    }
    
    func performFetch() {
        if let moc = managedObjectContext {
            // Fetch glossary items
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let sortDescriptor = NSSortDescriptor(key: "term", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)) )
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "glossaryItemCache")
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
            } catch {
                fatalError("Failed to initialize FetchedResultsController: \(error)")
            }
            
            // Fetch the number of items of glossary
            let countFetchRequest = NSFetchRequest(entityName: entityName)
            countFetchRequest.resultType = .CountResultType
            
            do {
                let results =
                    try managedObjectContext.executeFetchRequest(countFetchRequest) as! [NSNumber]
                let count = results.first!.integerValue
                glossaryCount = count
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
    
    func setGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.hideKeyboard(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
        searchBar.resignFirstResponder()
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
        
        if let text = searchBar.text {
            performFetchSearchResultByText(text)
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    func performFetchSearchResultByText(text: String) {
        let cacheName = "searchGlossaryItemCache"
        NSFetchedResultsController.deleteCacheWithName(cacheName)
        
        let searchFetchRequest = NSFetchRequest(entityName: entityName)
        let searchPredicate = NSPredicate(format: "term BEGINSWITH [cd]%@", text)   // for [cd], the c means case insensitive, d to ignore accents (a & á)
        let sortDescriptor = NSSortDescriptor(key: "term", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)) )
        searchFetchRequest.sortDescriptors = [sortDescriptor]
        searchFetchRequest.predicate = searchPredicate
        
        searchFetchedResultsController = NSFetchedResultsController(fetchRequest: searchFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: cacheName)
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
        
        guard !hasSearched || searchCount != 0 else {
            cellIdentifier = cellID.nothingFound
            let nothingFoundCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NothingFoundTableViewCell
            return nothingFoundCell
        }
        
        if hasSearched {
            itemContent = searchFetchedResultsController.objectAtIndexPath(indexPath) as! GlossaryItem
        } else {
            itemContent = fetchedResultsController.objectAtIndexPath(indexPath) as! GlossaryItem
        }
        
        if let path = selectedIndexPath {
            if indexPath.compare(path) == NSComparisonResult.OrderedSame {
                cellIdentifier = cellID.detailed
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GlossaryItemDetailedTableViewCell
                cell.delegate = self
                cell.indexPath = indexPath
                cell.configureForItem(itemContent)
                return cell
            } else {
                // SITUATION I
                cellIdentifier = cellID.brief
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GlossaryItemBriefTableViewCell
                cell.termLabel.text = itemContent.term
                return cell
            }
        } else {
            // SITUATION II
            // The SITUATION I & II are same. Still couldn't find a good way to avoid this repeat.
            cellIdentifier = cellID.brief
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
// So far the only element needs to change automatically is the like button.
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
        
        case .Update: // Update the heart
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

