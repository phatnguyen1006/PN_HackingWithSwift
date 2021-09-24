//
//  ViewController.swift
//  WordScramble
//
//  Created by Phat Nguyen on 19/09/2021.
//

import UIKit

class ViewController: UITableViewController {
    var todos = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .none
        
        setupBar()
    }
    
    // Config
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo", for: indexPath)
        
        // styles cell
        cell.textLabel!.attributedText = makeAttributedString(todos[indexPath.row])
        cell.backgroundColor = .none
        
        // selection
        // if not used init... it's not work...
        let view = UIView.init()
        view.backgroundColor = .orange.withAlphaComponent(0.3)
        cell.selectedBackgroundView = view

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Khi ấn vào thì xóa todos đó đi.
        todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func setupBar() {
        self.title = "Todo List"
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaped))
        addBtn.tintColor = .systemPink
        navigationItem.rightBarButtonItem = addBtn
    }
    
    @objc func addTaped() {
        // Create Controller
        let vc = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        vc.addTextField()
        // submit btntextfield
        let submitbtn = UIAlertAction(title: "add", style: .default) { [weak self, weak vc] _ in
            guard let todo = vc?.textFields?[0].text else { return }
            self?.onSubmit(todo)
        }
        submitbtn.setValue(UIColor.systemPink, forKey: "TitleTextColor")
        vc.addAction(submitbtn)
        
        present(vc, animated: true)
    }
    
    func onSubmit(_ todo: String) {
        todos.insert(todo, at: 0)
        setTable()
    }
    
    func setTable() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // style row
    func makeAttributedString(_ title: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.systemOrange]

        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)

        return titleString
    }

}

