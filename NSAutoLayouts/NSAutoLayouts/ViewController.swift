//
//  ViewController.swift
//  NSAutoLayouts
//
//  Created by Phat Nguyen on 21/09/2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initLabel()
    }
    
    func initLabel() {
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .red
        label1.text = "A"
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .green
        label2.text = "B"
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .cyan
        label3.text = "C"
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .orange
        label4.text = "D"
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = .blue
        label5.text = "E"
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        
//        visualFormatLanguage(viewsDictionary: viewsDictionary)
        anchor(viewsDictionary: viewsDictionary)
    }
    
    func visualFormatLanguage(viewsDictionary: [String: UILabel]) {
        
        
        for label in viewsDictionary.keys {
            // setting to View
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
            // Add List Contrains to view.
            // First: loop the viewDictionary and take the keys.
            // And give list contrains into "NSLayoutConstraint.constraints()".
            // into NSLayoutConstraint.constraints(): Pass the list into withVisualFormat attribute.
            // Here we use "withVisualFormat: String"
            // if we want to set the Horizontal -> pass: "H:|<List>[A]-[B]|" -> setup from Horizontal
        }
        
        let metrics = ["labelHeight" : 100]
        
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        
        /*
         Constraint priority is a value between 1 and 1000, where 1000 means "this is absolutely required" and anything less is optional.
         By default, all constraints you have are priority 1000, so Auto Layout will fail to find a solution in our current layout.
         But if we make the height optional – even as high as priority 999 – it means Auto Layout can find a solution to our layout: shrink the labels to make them fit.
         */
    }
    
    func anchor(viewsDictionary: [String: UILabel]) {
        var previous: UILabel?
        // first we will have a for loop
        for label in viewsDictionary.values {
            print(label);
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 88).isActive = true
            
            // portrait mode
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }

            previous = label
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

