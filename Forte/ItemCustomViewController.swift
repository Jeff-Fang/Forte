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
    @IBOutlet weak var noteTakingTextView: UITextView!
    
    var itemIndex: NSIndexPath?
    var termToDisplay = ""
    var meaningToDisplay = ""
    var noteToDisplay: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termLabel.text = termToDisplay
        meaningLabel.text = meaningToDisplay
        noteTakingTextView.text = noteToDisplay
        
        noteTakingTextView.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ItemCustomTableViewController.hideKeyboard(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        
        noteTakingTextView.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItemCustomVC" {
            noteToDisplay = noteTakingTextView.text
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            tableView.estimatedRowHeight = 200
            return UITableViewAutomaticDimension
        } else if indexPath.section == 1 {
            return 300
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            noteTakingTextView.becomeFirstResponder()
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            noteTakingTextView.resignFirstResponder()
        }
    }
}

extension ItemCustomTableViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        noteToDisplay = textView.text
    }
}

