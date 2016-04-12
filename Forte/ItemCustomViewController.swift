//
//  ItemCustomViewController.swift
//  Forte
//
//  Created by Jeff Fang on 4/12/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import CoreData

class ItemCustomTableViewController: UITableViewController {
    
    @IBOutlet weak var itemDetailCell: UITableViewCell!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var noteTakingField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        itemDetailCell.
        
        // Load glossary items from database
//        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//            let fetchRequest = NSFetchRequest(entityName: "GlossaryItem")
//            do {
//                glossary = try managedObjectContext.executeFetchRequest(fetchRequest) as! [GlossaryItem]
//            } catch {
//                print("Failed to retrieve record")
//                print(error)
//            }
        
        noteTakingField.text = "You can take notes here..."
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            tableView.estimatedRowHeight = 200
            return UITableViewAutomaticDimension
        } else if indexPath.section == 1 {
            return 200
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

extension ItemCustomTableViewController: UITextViewDelegate {
    
}

