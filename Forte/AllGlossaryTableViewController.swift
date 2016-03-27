//
//  AllGlossaryTableViewController.swift
//  Forte
//
//  Created by Jeff Fang on 3/27/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

class AllGlossaryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath) as! AllGlossaryTableViewCell
        // Configure the cell
        cell.termLabel.text = "TermTest"
        cell.meaningLabel.text = "MeaningTest"
        
        return cell
    }
}
