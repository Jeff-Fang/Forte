//
//  SettingsTableViewController.swift
//  Forte
//
//  Created by Jeff Fang on 5/2/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

// MARK: - Configure Menu Items

struct MenuItem {
    var text: String
    var row: Int
}

struct Section {
    var items: [MenuItem]
    var name: String
    var sectionNumber: Int
}

let wikiPage = MenuItem(text:"Music Glossary on Wikipedia", row: 1)
let aboutForte: [MenuItem] = [wikiPage]
let aboutSection = Section(items: aboutForte, name: "About", sectionNumber:1)

let rate = MenuItem(text: "Rate Forte on App Store", row: 0)
let sendFeedback = MenuItem(text: "Tell me your feedback", row: 1)
let reportProblem = MenuItem(text: "Report a problem", row: 2)
let feedback: [MenuItem] = [rate, sendFeedback, reportProblem]
let feedbackSection = Section(items: feedback, name: "Leave Feedback", sectionNumber: 2)

let myTwitter = MenuItem(text: "Twitter", row: 0)
let myWeibo = MenuItem(text: "Weibo", row: 1)
let followMe: [MenuItem] = [myTwitter, myWeibo]
let followMeSection = Section(items: followMe, name:"Follow Me", sectionNumber: 3)

let aboutPageMenu: [Section] = [aboutSection, feedbackSection, followMeSection]

func aboutPageMenuItemForIndexPath(index: NSIndexPath) -> MenuItem? {
    for sec in aboutPageMenu where sec.sectionNumber == index.section {
        for item in sec.items where item.row == index.row {
            return item
        }
    }
    return nil
}

class SettingsTableViewController: UITableViewController {
    
    let links = [myTwitter.text: "https://twitter.com/all2jeff",
                 myWeibo.text: "https://weibo.com/all2jeff",
                 wikiPage.text: "https://en.wikipedia.org/wiki/Glossary_of_musical_terminology",
                 rate.text: "http://www.apple.com/itunes/charts/paid-apps/"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cellItem = aboutPageMenuItemForIndexPath(indexPath) {
            switch cellItem.text{
            case wikiPage.text:
                if let url = NSURL(string: links[wikiPage.text]!) {
                    let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: false)
                    presentViewController(safariController, animated: true, completion: nil)
                }
                
            case rate.text:
                if let url = NSURL(string:links[rate.text]!) {
                    UIApplication.sharedApplication().openURL(url)
                }
                
            case sendFeedback.text:
                showEmailForKey(sendFeedback.text)
                
            case reportProblem.text:
                showEmailForKey(sendFeedback.text)
                
            case myTwitter.text:
                if let url = NSURL(string: links[myTwitter.text]!) {
                    let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: false)
                    presentViewController(safariController, animated: true, completion: nil)
                }
            case myWeibo.text:
                if let url = NSURL(string: links[myWeibo.text]!) {
                    let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: false)
                    presentViewController(safariController, animated: true, completion: nil)
                }
                
            default:
                break
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func showEmailForKey(key: String) {
        print("*** sending mails .....")
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let messageBody = ""
        let toRecipients = ["all2jeff@gmail.com"]
        var emailTitle = ""
        
        if key == sendFeedback.text {
            emailTitle = "Feedback of Forte"
        } else if key == reportProblem.text {
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

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
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
