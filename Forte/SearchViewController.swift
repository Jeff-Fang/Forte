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
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    private var searchFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    private var entityName = "GlossaryItem"
    private var hasSearched = false
    private var glossaryCount: Int = 0
    private var searchCount: Int = 0
    
    private var indexPathsToUpdate = [IndexPath] ()
    private var prevSelectedIndexPath: IndexPath? = nil
    private var selectedIndexPath: IndexPath? {
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
        searchBar.barTintColor = UIColor.white()
        //        searchBar.tintColor = UIColor.whiteColor()
        searchBar.tintColor = UIColor(colorLiteralRed: 255/255 , green: 80/255 , blue: 100/255 , alpha: 1)
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor(colorLiteralRed: 230/255 , green: 230/255 , blue: 230/255 , alpha: 1)
                }
            }
        }
    }
    
    func prepareTableView() {
        tableView.contentInset.top = 64
        tableView.contentInset.bottom = 66
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func loadNibFiles() {
        var cellNib = UINib(nibName: cellID.brief, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellID.brief)
        cellNib = UINib(nibName: cellID.nothingFound, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellID.nothingFound)
        cellNib = UINib(nibName: cellID.detailed, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellID.detailed)
    }
    
    func performFetch() {
        if let moc = managedObjectContext {
            // Fetch glossary items
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let sortDescriptor = SortDescriptor(key: "term", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)) )
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
            let countFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            countFetchRequest.resultType = .countResultType
            
            do {
                let results =
                    try managedObjectContext.fetch(countFetchRequest) as! [NSNumber]
                let count = results.first!.intValue
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
    
    func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        selectedIndexPath = nil
        tableView.reloadData()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        hasSearched = false
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func performFetchSearchResultByText(_ text: String) {
        let cacheName = "searchGlossaryItemCache"
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: cacheName)
        
        let searchFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let searchPredicate = Predicate(format: "term BEGINSWITH [cd]%@", text)   // for [cd], the c means case insensitive, d to ignore accents (a & á)
        let sortDescriptor = SortDescriptor(key: "term", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)) )
        searchFetchRequest.sortDescriptors = [sortDescriptor]
        searchFetchRequest.predicate = searchPredicate
        
        searchFetchedResultsController = NSFetchedResultsController(fetchRequest: searchFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: cacheName)
        searchFetchedResultsController.delegate = self
        
        do {
            try searchFetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        let countFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        countFetchRequest.resultType = .countResultType
        countFetchRequest.predicate = searchPredicate
        
        do {
            let results =
            try managedObjectContext.fetch(countFetchRequest) as! [NSNumber]
            let count = results.first!.intValue
            searchCount = count
            print("*** searchCount = \(searchCount)")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}

// MARK: - UITableViewDataSourceDelegate
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultRowHeight:CGFloat = 56.5
        
        if hasSearched && searchCount == 0 {
            // for NoResultFoundCell
            return 88
        } else if let path = selectedIndexPath {
            if (indexPath as NSIndexPath).compare(path) == ComparisonResult.orderedSame {
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
    
    @objc(tableView:estimatedHeightForRowAtIndexPath:) func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var itemContent: GlossaryItem
        
        guard !hasSearched || searchCount != 0 else {
            cellIdentifier = cellID.nothingFound
            let nothingFoundCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NothingFoundTableViewCell
            return nothingFoundCell
        }
        
        if hasSearched {
            itemContent = searchFetchedResultsController.object(at: indexPath) as! GlossaryItem
        } else {
            itemContent = fetchedResultsController.object(at: indexPath) as! GlossaryItem
        }
        
        if let path = selectedIndexPath {
            if (indexPath as NSIndexPath).compare(path) == ComparisonResult.orderedSame {
                cellIdentifier = cellID.detailed
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GlossaryItemDetailedTableViewCell
                cell.delegate = self
                cell.indexPath = indexPath
                cell.configureForItem(itemContent)
                return cell
            } else {
                // SITUATION I
                cellIdentifier = cellID.brief
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GlossaryItemBriefTableViewCell
                cell.termLabel.text = itemContent.term
                return cell
            }
        } else {
            // SITUATION II
            // The SITUATION I & II are same. Still couldn't find a good way to avoid this repeat.
            cellIdentifier = cellID.brief
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GlossaryItemBriefTableViewCell
            cell.termLabel.text = itemContent.term
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathsToUpdate.removeAll(keepingCapacity: false)
        
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
        tableView.reloadRows(at: indexPathsToUpdate, with: UITableViewRowAnimation.automatic)
    }
}

// MARK: - CellDelegate
extension SearchViewController: InCellFunctionalityDelegate {
    func inCellButtonIsPressed(_ cell: GlossaryItemDetailedTableViewCell) {
        let indexPath = cell.indexPath
        var pressedItem: GlossaryItem!
        
        if hasSearched {
            pressedItem = searchFetchedResultsController.object(at: indexPath) as! GlossaryItem
        } else {
            pressedItem = fetchedResultsController.object(at: indexPath) as! GlossaryItem
        }
        
        var markSign: Bool {
            get {
                return pressedItem.isMarked.boolValue
            }
            set(value) {
                pressedItem.setValue(value, forKey: "isMarked")
                pressedItem.setValue(Date(), forKey: "markedDate")
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
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        
        case .update: // Update the heart
            print("*** NSFetchedResultsChangeUpdate (object)")
            guard selectedIndexPath != indexPath else {
                if let cell = tableView.cellForRow(at: indexPath!) as? GlossaryItemDetailedTableViewCell {
                    let item = controller.object(at: indexPath!) as! GlossaryItem
                    cell.configureForItem(item)
                }
                break
            }

        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
    
}

