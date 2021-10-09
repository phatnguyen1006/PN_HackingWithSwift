//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Phat Nguyen on 27/09/2021.
//

import UIKit

class ViewController: UIViewController {
    // components
    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scoresLabel: UILabel!
    var submit: UIButton!
    var clear: UIButton!
    var letterButton = [UIButton]()
    var buttonsView: UIView!
    //
    var activatedButton = [UIButton]()
    var solutions = [String]()
    //
    var scores = 0
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // Add more code here!
        setupLabel()
        setupButton()
        setupSubView()
        autoLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        // before layout => width && height == 0
        // after layout subview => width / height
        print("re-layout subviews")
        createLetterBtn()
        // load to the start level
        loadLevel()
    }
    
    func setupLabel() {
        // scores
        scoresLabel = UILabel()
        scoresLabel.translatesAutoresizingMaskIntoConstraints = false   // Avoid crash UI
        scoresLabel.textAlignment = .right
        scoresLabel.text = "Scores: 0"
        
        // clues
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        
        // answers
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.numberOfLines = 0
        answerLabel.text = "ANSWERS"
        answerLabel.textAlignment = .right
        
        // textField
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints =  false
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        
        // present
        view.addSubview(scoresLabel)
        view.addSubview(cluesLabel)
        view.addSubview(answerLabel)
        view.addSubview(currentAnswer)
        
    }
    
    func setupButton() {
        submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        // present
        view.addSubview(submit)
        view.addSubview(clear)
    }
    
    func setupSubView() {
        buttonsView = UIView()
        buttonsView.backgroundColor = .green
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
    }
    
    func createLetterBtn() {
        // add buttons
        let width = (buttonsView.bounds.width) / 5.0
        let height = (buttonsView.bounds.height) / 4.0
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterbutton = UIButton(type: .system)
                letterbutton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterbutton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterbutton.isUserInteractionEnabled = true
                
                let frame = CGRect(x: CGFloat(col)*width, y: CGFloat(row)*height, width: width, height: height)
                letterbutton.frame = frame
                
                buttonsView.addSubview(letterbutton)
                letterButton.append(letterbutton)
            }
        }
    }
    
    func autoLayout() {
        // auto Layout
        NSLayoutConstraint.activate([
            // Scores: Top Right
            scoresLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoresLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            // Clues: Center Left
            cluesLabel.topAnchor.constraint(equalTo: scoresLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            // Answer: Center right
            answerLabel.topAnchor.constraint(equalTo: scoresLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            // current Answer: TextField
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 40),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.5),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 2 buttons
            // submit: pr-100
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            // clear: pl-100
            clear.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            // buttonsView: Center bottom
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 40),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            buttonsView.heightAnchor.constraint(equalToConstant: 400),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])
    }
    
    func loadLevel() {
        var cluesString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        if let levelFileUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileUrl) {
                // array is divided by character "\n"
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    cluesString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionsString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        // random and complete the repair.
        cluesLabel.text = cluesString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        // random
        letterBits.shuffle()
        
        if letterBits.count == letterButton.count {
            for i in 0..<letterButton.count {
                letterButton[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll()
        
        //            loadLevel()
        
        for btn in letterButton {
            btn.isHidden = false
        }
        
    }
    
    // Object-C
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

            if let solutionPosition = solutions.firstIndex(of: answerText) {
                activatedButton.removeAll()

                var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
                splitAnswers?[solutionPosition] = answerText
                answerLabel.text = splitAnswers?.joined(separator: "\n")

                currentAnswer.text = ""
                scores += 1

                if scores % 7 == 0 {
                    let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                    present(ac, animated: true)
                }
            }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        print("button title: \(buttonTitle)")
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButton.append(sender)
        sender.isHidden = true
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for btn in activatedButton {
            btn.isHidden = false
        }
        
        activatedButton.removeAll()
    }
}

