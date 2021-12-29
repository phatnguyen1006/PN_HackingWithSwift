//
//  ViewController.swift
//  Local Notifications
//
//  Created by Phat Nguyen on 26/12/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar()
    }
    
    func navBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        /// UNNotificationAction: Create Action Button for Notification Category on Lock Screen.
        /// UNNotificationCategory: Create a category contain an action inside.
        /// setNotificationCategories: Register Categories for Notifications.
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more ...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
        
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yeee")
            } else {
                print("Ohhhh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Wake up"
        content.body = "A new day, new creatives"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        // set Time to alert
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // pull out userInfo when receive data...
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // user swipe to unlock
                print("Default data")
            case "show":
                // the user tapped our "show more info…" button
                print("Show more information ...")
            default:
                break
            }
        }
        
        // must call completion when we done to alert to iOS ... hanlder is done
        completionHandler()
    }
}
