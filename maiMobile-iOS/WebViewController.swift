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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = false
        webView.delegate = self
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
}
