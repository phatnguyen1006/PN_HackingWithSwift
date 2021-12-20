//
//  ViewController.swift
//  InstaFilter
//
//  Created by Phat Nguyen on 24/10/2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    
    var currentImage: UIImage!
    
    /*
     The first is a Core Image context, which is the Core Image component that handles rendering. We create it here and use it throughout our app, because creating a context is computationally expensive so we don't want to keep doing it.
     
     The second is a Core Image filter, and will store whatever filter the user has activated. This filter will be given various input settings before we ask it to output a result for us to show in the image view.
     */
    var context: CIContext!
    var currentFilter: CIFilter!
    
    
    override func viewDidLoad() {
        title = "InstaFilter"
        importImageCtrl()
        createCoreContext()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func createCoreContext() {
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    func importImageCtrl() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaped))
    }
    
    @objc func addTaped() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    func setFilter(action: UIAlertAction) {
        // make sure we have a valid image before setFilter
        guard currentImage != nil else {return}
        
        // safety read the action's title
        guard let actionTitlte = action.title else {return}
        
        currentFilter = CIFilter(name: actionTitlte)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        //        guard let image = currentFilter.outputImage else {return}
        //        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        //
        //        if let cgImg = context.createCGImage(image, from: image.extent) {
        //            let processedImg = UIImage(cgImage: cgImg)
        //            imageView.image = processedImg
        //        }
        
        // cunning
        let inputKey = currentFilter.inputKeys  // return an array contains the keys it will be support
        
        // see the filter type we can use
        if inputKey.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKey.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKey.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKey.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width, y: currentImage.size.height), forKey: kCIInputCenterKey) }
        
        if let cgImg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImg = UIImage(cgImage: cgImg)
            self.imageView.image = processedImg
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved into Photo Albums", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
}
