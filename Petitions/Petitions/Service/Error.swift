//
//  Error.swift
//  Petitions
//
//  Created by Phat Nguyen on 25/09/2021.
//

import Foundation
import UIKit


func catchError(_ title: String,_ message: String) -> UIAlertController {
    // create AlertController
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    // create action
    let action = UIAlertAction(title: "OK", style: .default)
    ac.addAction(action)
    
    // return to present function
    return ac
}

//    func presentToRootScreen(alert: UIAlertController) {
//
//        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//        alertWindow.rootViewController = ViewController() as UITableViewController
//        alertWindow.windowLevel = UIWindow.Level.alert + 2;
//        alertWindow.makeKeyAndVisible()
//        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
//    }

