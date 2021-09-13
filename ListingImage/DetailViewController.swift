//
//  DetailViewController.swift
//  ListingImage
//
//  Created by Phat Nguyen on 13/09/2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var seletedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = .white
        customTitle()

        // show SelectedImage
        showSelectedImage()
    }
    
    func customTitle() {
        self.title = self.seletedImage
        // custom: never use Large Title
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func showSelectedImage() {
        if let imageToLoad = self.seletedImage {
            self.imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
