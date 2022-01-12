//
//  ViewController.swift
//  Secret Swift
//
//  Created by Phat Nguyen on 12/01/2022.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        setupNotificationCenter()
    }
    
    func setupNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func unlockSecretMessage() {
        // show content
        secret.isHidden = false
        title = "Secret"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.isHidden = true
        secret.resignFirstResponder()
        title = "Nothing to see here"
        
    }
    
    @objc func adjustForKeyboard(notication: Notification) {
        guard let keyboardValue = notication.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notication.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticateError in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    if success {
                        strongSelf.unlockSecretMessage()
                    } else {
                        // failed to authenticate
                        let ac = UIAlertController(title: "Authenticaion failed", message: "You could not be verified! Please try again!", preferredStyle: .alert)
                        
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        strongSelf.present(ac, animated: true)
                    }
                }
            }
        }
        else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not support this future", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
}

