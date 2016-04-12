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
    }

}

extension ItemCustomTableViewController: UITextViewDelegate {
    
}

