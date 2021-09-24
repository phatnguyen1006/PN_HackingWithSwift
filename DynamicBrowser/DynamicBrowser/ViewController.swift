//
//  ViewController.swift
//  DynamicBrowser
//
//  Created by Phat Nguyen on 16/09/2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["github.com/phatnguyen1006", "apple.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // right Bar button
        setupOpenBtn()
        // tool Bar
        setupToolBar()
        
        // Embed
        setupWebView()
    }
    
    func setupOpenBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTaped))
    }
    
    @objc func openTaped() {
        // Create controller
        let ac = UIAlertController(title: "Open another website", message: nil, preferredStyle: .actionSheet)
        
        // Create action and add action
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cancel.setValue(UIColor.red, forKey: "TitleTextColor")
        
        ac.addAction(cancel)
        // Avoid crash on Ipad
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        // show out
        present(ac, animated: true)
    }
    
    func setupToolBar() {
        // a progress
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progress = UIBarButtonItem(customView: progressView)
        // flexible spacer have not target or action
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // refresh button
        // target is WebView => action call the webView.reload()
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // add btn to toolbar
        self.toolbarItems = [progress, spacer, refreshBtn]
        navigationController?.isToolbarHidden = false
        
        // Observer for progress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func setupWebView() {
        // Define url of WebSite
        let url = URL(string: "https://" + websites[0])
        // Load Request to WebSite
        webView.load(URLRequest(url: url!))
        // Allow Back by Swipe
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func openPage(action: UIAlertAction) {
        guard let url = URL(string: "https://" + action.title!) else { return }
        // Load the new WebSite
        // Load Request to WebSite
        webView.load(URLRequest(url: url))
        // Allow Back by Swipe
        webView.allowsBackForwardNavigationGestures = true
    }
}

extension ViewController: WKNavigationDelegate {
    override func loadView() {
        self.webView = WKWebView()
        // Delegate the WebView
        self.webView.navigationDelegate = self
        // Delegate the view to WebView
        self.view = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
    
    // Custom a progress view
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // Config extension WebView to just allow load to page have host.contains(website) == true
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    //        let url = navigationAction.request.url
    //
    //        if let host = url?.host {
    //            for website in websites {
    //                if host.contains(website) {
    //                    decisionHandler(.allow)
    //                    return
    //                }
    //            }
    //        }
    //
    //        decisionHandler(.cancel)
    //    }
}

