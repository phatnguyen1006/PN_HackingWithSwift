//
//  DetailViewController.swift
//  Petitions
//
//  Created by Phat Nguyen on 25/09/2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var petitionItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webViewHTML()
    }
    
    func webViewHTML() {
        if let html = HTML(petitionItem!) as String? {
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
}
