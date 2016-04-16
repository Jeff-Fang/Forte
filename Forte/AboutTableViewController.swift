//
//  AboutTableViewController.swift
//  Forte
//
//  Created by Jeff Fang on 4/17/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitles = ["","Leave Feedback","Follow Me"]
    var sectionContent = [["Music Glossary on Wikipedia"],["Rate Forte on App Store", "Tell me your feedback", "Report a problem"],["Twitter", "Weibo"]]
    var links = ["https://twitter.com/all2jeff","https://weibo.com/all2jeff"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            if let url = NSURL(string: "https://en.wikipedia.org/wiki/Glossary_of_musical_terminology") {
                let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: false)
                presentViewController(safariController, animated: true, completion: nil)
            }
        
        case 1:
            if indexPath.row == 0 {
                if let url = NSURL(string:"http://www.apple.com/itunes/charts/paid-apps/") {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            
        case 2:
            if let url = NSURL(string: links[indexPath.row]) {
                let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: false)
                presentViewController(safariController, animated: true, completion: nil)
            }
            
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

}
