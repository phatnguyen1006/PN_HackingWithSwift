//
//  ActionViewController.swift
//  JavaScriptIDE
//
//  Created by Phat Nguyen on 20/12/2021.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageURL = ""
    var pageTitle = ""
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightBarBtn()
        setupKeyboardNotifications()
    
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypeIdentifierKey as String) { [weak self] dict, error in
                    guard let strongSelf = self else { return }
                    
                    // receive the javascript code and value
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    strongSelf.pageURL = javaScriptValues["URL"] as? String ?? ""
                    strongSelf.pageTitle = javaScriptValues["Title"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        strongSelf.title = strongSelf.pageTitle;
                    }
                }
            }
        }
    }
    
    func setupRightBarBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    func setupKeyboardNotifications() {
        let notificationCenter =  NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @IBAction func done() {
        
        // return to parent app and give it to ActionJS
        let item = NSExtensionItem()
        let arguments: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: arguments]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypeIdentifierKey as String)
        item.attachments = [customJavaScript]
        
        self.extensionContext!.completeRequest(returningItems: [item])
    }
    
    @objc func adjustKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let seletedRange = script.selectedRange
        script.scrollRangeToVisible(seletedRange)
    }

}
