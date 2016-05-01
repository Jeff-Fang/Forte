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
    
    // MARK: - Class Properties

    @IBOutlet weak var itemDetailCell: UITableViewCell!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var noteTakingTextView: UITextView!
    @IBOutlet weak var originLabel: UILabel!
    
    // MARK: - Class Settings

    var itemIndex: NSIndexPath?
    var termToDisplay = ""
    var meaningToDisplay = ""
    var noteToDisplay: String?
    var originToDisplay: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCells()
        setGestureRecognizer()
    }
    
    func prepareCells() {
        termLabel.text = termToDisplay
        meaningLabel.text = meaningToDisplay
        noteTakingTextView.text = noteToDisplay
        originLabel.text = originToDisplay
        
        noteTakingTextView.delegate = self
    }
    
    func setGestureRecognizer() {
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
    
    // MARK: - Dealing with Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItemCustomVC" {
            noteToDisplay = noteTakingTextView.text
        }
    }
    
    // MARK: - UITableViewDataSourceDelegate

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
    
    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            noteTakingTextView.becomeFirstResponder()
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            noteTakingTextView.resignFirstResponder()
        }
    }
}

// MARK: - UITextViewDelegate

extension ItemCustomTableViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        noteToDisplay = textView.text
    }
}

