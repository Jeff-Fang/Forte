//
//  AboutAppViewController.swift
//  Forte
//
//  Created by Jeff Fang on 5/2/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    @IBOutlet weak var aboutWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutWebView.delegate = self

        // Do any additional setup after loading the view.
        if let htmlFile = NSBundle.mainBundle().pathForResource("Forte 1.0", ofType: "html") {
            if let htmlData = NSData(contentsOfFile: htmlFile) {
                let baseURL = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath)
                aboutWebView.loadData(htmlData, MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AboutAppViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            if let url = request.URL {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        return true
    }
}
