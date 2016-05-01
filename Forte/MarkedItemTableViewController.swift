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
    var fetchedResultsController: NSFetchedResultsController!
    
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
        var fetchRequest = NSFetchRequest()
        if let moc = managedObjectContext {
            let managedObjectModel = moc.persistentStoreCoordinator!.managedObjectModel
            fetchRequest = managedObjectModel.fetchRequestTemplateForName("MarkedItem")!.copy() as! NSFetchRequest
            
            let sortDescriptor1 = NSSortDescriptor(key: "markedDate", ascending: false)
            let sortDescriptor2 = NSSortDescriptor(key: "term", ascending: true)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
    
    @IBAction func itemCustomVCDidFinishEditing(segue: UIStoryboardSegue) {
        let controller = segue.sourceViewController as! ItemCustomTableViewController
        let itemNote = controller.noteToDisplay
        let itemIndex = controller.itemIndex
        
        saveNote(itemNote, atIndexPath: itemIndex!)
    }
    
    func saveNote(note: String?, atIndexPath path: NSIndexPath) {
        let item = fetchedResultsController.objectAtIndexPath(path) as! GlossaryItem
        item.note = note
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - UITableViewDataSourceDelegate

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MarkedItemCell", forIndexPath: indexPath) as! MarkedItemTableViewCell
        
        let markedItem = fetchedResultsController.objectAtIndexPath(indexPath) as! GlossaryItem
        cell.cellIndexPath = indexPath
        cell.configureForItem(markedItem)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = fetchedResultsController.objectAtIndexPath(indexPath) as! GlossaryItem
            
            item.isMarked = false
            item.markedDate = nil
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension MarkedItemTableViewController: NSFetchedResultsControllerDelegate {
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
            
        case .Update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? MarkedItemTableViewCell {
                let markedItem = controller.objectAtIndexPath(indexPath!) as! GlossaryItem
                cell.configureForItem(markedItem)
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

