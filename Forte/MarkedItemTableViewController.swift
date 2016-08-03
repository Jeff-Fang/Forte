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
    
    // MARK: - Class Properties
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    // MARK: - Class Settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        performFetch()
    }
    
    func prepareTableView() {
        tableView.rowHeight = 80
//        tableView.tableFooterView = UIView(frame: CGRectZero) // ! This will strangely cause fatal error.
    }
    
    func performFetch() {
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        if let moc = managedObjectContext {
            let managedObjectModel = moc.persistentStoreCoordinator!.managedObjectModel
            fetchRequest = managedObjectModel.fetchRequestTemplate(forName: "MarkedItem")!.copy() as! NSFetchRequest
            
            let sortDescriptor1 = SortDescriptor(key: "markedDate", ascending: false)
            let sortDescriptor2 = SortDescriptor(key: "term", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
            fetchRequest.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "markedItemCache")
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Dealing with Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItemCustomVC" {
            let cell = sender as! MarkedItemTableViewCell
            let controller = segue.destinationViewController as! ItemCustomTableViewController
            controller.termToDisplay = cell.markedTermLabel.text!
            controller.meaningToDisplay = cell.markedMeaningLabel.text!
            controller.noteToDisplay = cell.markedItemNote
            controller.itemIndex = cell.cellIndexPath
            controller.originToDisplay = cell.origin
        }
    }
    
    @IBAction func itemCustomVCDidFinishEditing(_ segue: UIStoryboardSegue) {
        let controller = segue.sourceViewController as! ItemCustomTableViewController
        let itemNote = controller.noteToDisplay
        let itemIndex = controller.itemIndex
        
        saveNote(itemNote, atIndexPath: itemIndex! as IndexPath)
    }
    
    func saveNote(_ note: String?, atIndexPath path: IndexPath) {
        let item = fetchedResultsController.object(at: path) as! GlossaryItem
        item.note = note
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - UITableViewDataSourceDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkedItemCell", for: indexPath) as! MarkedItemTableViewCell
        
        let markedItem = fetchedResultsController.object(at: indexPath) as! GlossaryItem
        cell.cellIndexPath = indexPath
        cell.configureForItem(markedItem)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath) as! GlossaryItem
            
            item.setValue(false, forKey: "isMarked")
            item.markedDate = nil
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension MarkedItemTableViewController: NSFetchedResultsControllerDelegate {
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
            
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!) as? MarkedItemTableViewCell {
                let markedItem = controller.object(at: indexPath!) as! GlossaryItem
                cell.configureForItem(markedItem)
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

