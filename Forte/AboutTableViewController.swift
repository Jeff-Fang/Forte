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

struct MenuItem {
    var text: String
    var row: Int
}

struct Section {
    var items: [MenuItem]
    var name: String
    var sectionNumber: Int
}

// MARK: - Configure Menu Items

let wikiPage = MenuItem(text:"Music Glossary on Wikipedia", row: 0)
let aboutForte: [MenuItem] = [wikiPage]
let aboutSection = Section(items: aboutForte, name: "About", sectionNumber:0)

let rate = MenuItem(text: "Rate Forte on App Store", row: 0)
let sendFeedback = MenuItem(text: "Tell me your feedback", row: 1)
let reportProblem = MenuItem(text: "Report a problem", row: 2)
let feedback: [MenuItem] = [rate, sendFeedback, reportProblem]
let feedbackSection = Section(items: feedback, name: "Leave Feedback", sectionNumber: 1)

let myTwitter = MenuItem(text: "Twitter", row: 0)
let myWeibo = MenuItem(text: "Weibo", row: 1)
let followMe: [MenuItem] = [myTwitter, myWeibo]
let followMeSection = Section(items: followMe, name:"Follow Me", sectionNumber: 2)

let aboutPageMenu: [Section] = [aboutSection, feedbackSection, followMeSection]

func aboutPageMenuItemForIndexPath(index: NSIndexPath) -> MenuItem? {
    for sec in aboutPageMenu {
        if sec.sectionNumber == index.section {
            for item in sec.items {
                if item.row == index.row {
                    return item
                }
            }
        }
    }
    return nil
}

//MARK: - ViewController

class AboutTableViewController: UITableViewController {

    // MARK: - Class Properties

    let links = [myTwitter.text: "https://twitter.com/all2jeff",
                 myWeibo.text: "https://weibo.com/all2jeff",
                 wikiPage.text: "https://en.wikipedia.org/wiki/Glossary_of_musical_terminology",
                 rate.text: "http://www.apple.com/itunes/charts/paid-apps/"]


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
        return aboutPageMenu.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        for sct in aboutPageMenu {
            if sct.sectionNumber == section {
                number = sct.items.count
            }
        }
        return number
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sctTitle: String?
        for sct in aboutPageMenu {
            if sct.sectionNumber == section {
                sctTitle = sct.name
            }
        }
        return sctTitle
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if let itemInfo = aboutPageMenuItemForIndexPath(indexPath) {
            cell.textLabel?.text = itemInfo.text
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate

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
