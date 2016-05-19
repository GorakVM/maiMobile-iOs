//
//  WebViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 19/05/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var url = NSURL()
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("webViewDidFinishLoad")
    }
    
    
}
