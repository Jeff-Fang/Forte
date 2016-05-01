//
//  AboutTableViewController.swift
//  Forte
//
//  Created by Jeff Fang on 4/17/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class AboutTableViewController: UITableViewController {

    // MARK: - Class Properties

    var sectionTitles = ["About","Leave Feedback","Follow Me"]
    var sectionContent = [["Music Glossary on Wikipedia"],
                          ["Rate Forte on App Store", "Tell me your feedback", "Report a problem"],
                          ["Twitter", "Weibo"]]
    var links = ["https://twitter.com/all2jeff","https://weibo.com/all2jeff"]

    // MARK: - Class Settings

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSourceDelegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // MARK: - UITableViewDelegate

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
            } else {
                showEmailForRow(indexPath.row)
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
    
    func showEmailForRow(row:Int) {
        print("*** sending mails .....")
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let messageBody = ""
        let toRecipients = ["all2jeff@gmail.com"]
        var emailTitle = ""
        
        if row == 1 {
            emailTitle = "Feedback of Forte"
        } else if row == 2 {
            emailTitle = "Problem of Forte"
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        presentViewController(mailComposer, animated: true, completion: nil)
    }

}

// MARK: - MFMailComposeViewControllerDelegate

extension AboutTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Failed to send: \(error)")
        default: break
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
