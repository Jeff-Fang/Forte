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
        if let htmlFile = Bundle.main.path(forResource: "Forte 1.0", ofType: "html") {
            if let htmlData = try? Data(contentsOf: URL(fileURLWithPath: htmlFile)) {
                let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                aboutWebView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AboutAppViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            if let url = request.url {
//                UIApplication.shared().openURL(url)
                UIApplication.shared.open(url, options: ["url":url], completionHandler: nil)
            }
        }
        return true
    }
}
