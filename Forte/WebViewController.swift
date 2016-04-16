//
//  WebViewController.swift
//  Forte
//
//  Created by Jeff Fang on 4/17/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = NSURL(string: "https://en.wikipedia.org/wiki/Glossary_of_musical_terminology") {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
