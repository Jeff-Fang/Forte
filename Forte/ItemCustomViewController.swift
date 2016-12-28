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

    var itemIndex: IndexPath?
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
    
    func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath != nil && (indexPath! as NSIndexPath).section == 0 && (indexPath! as NSIndexPath).row == 0 {
            return
        }
        
        noteTakingTextView.resignFirstResponder()
    }
    
    // MARK: - Dealing with Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemCustomVC" {
            noteToDisplay = noteTakingTextView.text
        }
    }
    
    // MARK: - UITableViewDataSourceDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            tableView.estimatedRowHeight = 200
            return UITableViewAutomaticDimension
        } else if (indexPath as NSIndexPath).section == 1 {
            return 300
        } else {
            return 44
        }
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            noteTakingTextView.becomeFirstResponder()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            noteTakingTextView.resignFirstResponder()
        }
    }
}

// MARK: - UITextViewDelegate

extension ItemCustomTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        noteToDisplay = textView.text
    }
}

