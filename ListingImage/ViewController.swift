//
//  ViewController.swift
//  ListingImage
//
//  Created by Phat Nguyen on 12/09/2021.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        customTitle()
        
        // Do any additional setup after loading the view.
        listingImage()
    }
    
    func customTitle() {
        self.title = "Photos"
        // custom color and large-title
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func listingImage() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("img") {
                // add to List
                pictures.append(item)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // Style
        cell.textLabel?.text = pictures[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.seletedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

