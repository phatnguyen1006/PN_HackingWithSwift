//
//  ViewController.swift
//  Petitions
//
//  Created by Phat Nguyen on 23/09/2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        onInitData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel!.text = petition.title
        cell.textLabel!.font = UIFont.systemFont(ofSize: 18.0)
        cell.detailTextLabel!.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.petitionItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func onInitData() {
        if let data = Services.fetchData() as [Petition]? {
            petitions = data
            tableView.reloadData()
        }
    }
}

