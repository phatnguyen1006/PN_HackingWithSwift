//
//  ViewController.swift
//  GuessFlag
//
//  Created by Phat Nguyen on 15/09/2021.
//

import UIKit

class ViewController: UIViewController {
    var countries = [String]()
    var scores = 0
    var correctAnswer = 0
    
    // Buttons Group
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Setup
        setupContries()
        setupBtn()
        
        // Start Question
        askQuestion()
    }

    func setupContries() {
        self.countries += ["france", "germany", "uk", "us"]
    }
    
    func setupBtn() {
        // BorderWidth
        self.btn1.layer.borderWidth = 1.0
        self.btn2.layer.borderWidth = 1.0
        self.btn3.layer.borderWidth = 1.0
        
        // BorderColor
        // !!! [Notes] : BorderColor use CGColor -> Convert UIColor -> CGColor
        self.btn1.layer.borderColor = UIColor.gray.cgColor
        self.btn2.layer.borderColor = UIColor.gray.cgColor
        self.btn3.layer.borderColor = UIColor.gray.cgColor
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        // Random Flag
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        // Set Title
        self.title = countries[correctAnswer].uppercased()

        self.btn1.setImage(UIImage(named: self.countries[0]), for: .normal)
        self.btn2.setImage(UIImage(named: self.countries[1]), for: .normal)
        self.btn3.setImage(UIImage(named: self.countries[2]), for: .normal)
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        var alert: String
        if sender.tag == self.correctAnswer {
            alert = "Correct"
            scores += 1
        }
        else {
            alert = "Wrong"
        }
        
        // Create AlertController
        let ac = UIAlertController(title: alert, message: "Your score is \(scores)", preferredStyle: .alert)
        
        // Add action into Controller
        // askQuestion is callback
        // -> Pass UIAlertAction! to create closure
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        // Present to Screen
        present(ac, animated: true)
    }
}

