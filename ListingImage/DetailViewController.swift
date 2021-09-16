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
        customShareBtn()
        
        // show SelectedImage
        showSelectedImage()
    }
    
    func customTitle() {
        self.title = self.seletedImage
        // custom: never use Large Title
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func customShareBtn() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTaped))
    }
    
    @objc func shareTaped() {
        // Shared Image
        guard let sharedImage = self.imageView.image else {
            print("No Image to share")
            return
        }
        
        // Create activity Controller
        // activityItems: Contain objects we want to share.
        let vc = UIActivityViewController(activityItems: [sharedImage], applicationActivities: [])
        // Add activity in to Controller
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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
