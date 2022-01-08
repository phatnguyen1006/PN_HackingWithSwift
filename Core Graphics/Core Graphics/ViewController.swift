//
//  ViewController.swift
//  Core Graphics
//
//  Created by Phat Nguyen on 07/01/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }
    
    func drawRectangle() {
        
    }

    @IBAction func redrawBtn(_ sender: Any) {
        // if type > 5 => reset value to 0
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        default:
            break
        }
    }
    
}

