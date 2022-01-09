//
//  ViewController.swift
//  Core Graphics
//
//  Created by Phat Nguyen on 07/01/2022.
//

/**
 * Core Graphics context is exposed to us when we render with UIGraphicsImageRenderer.
 * When you create a renderer, you get to specify how big it should be, whether it should be opaque or not, and what pixel to point scale you want. To kick off rendering you can either call the image() function to get back a UIImage of the results, or call the pngData() and jpegData() methods to get back a Data object in PNG or JPEG format respectively.
 */

/**
 five new methods you'll need to use to draw our box:

  1 setFillColor() sets the fill color of our context, which is the color used on the insides of the rectangle we'll draw.
  2 setStrokeColor() sets the stroke color of our context, which is the color used on the line around the edge of the rectangle we'll draw.
  3 setLineWidth() adjusts the line width that will be used to stroke our rectangle. Note that the line is drawn centered on the edge of the rectangle, so a value of 10 will draw 5 points inside the rectangle and five points outside.
  4 addRect() adds a CGRect rectangle to the context's current path to be drawn.
  5 drawPath() draws the context's current path using the state you have configured.
 */

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }
    
    func drawRectangle() {
        let rerender = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = rerender.image { ctx in
            // draw
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
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

