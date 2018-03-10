//
//  ViewController.swift
//  secretPhoto
//
//  Created by Tanner W. Stokes on 3/9/18.
//  Copyright © 2018 Tanner W. Stokes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func loadImage(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            debugPrint("Source wasn't available.")
            return
        }
        
        present(imagePicker, animated: true) {
            debugPrint("Presented")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // because ViewController satisfies the procols a UIImagePickerController delegate needs,
        // it can be assigned as the delegate
        imagePicker.delegate = self
        
        let imageSource = UIImagePickerControllerSourceType.camera
        let mediaTypes =  UIImagePickerController.availableMediaTypes(for: imageSource)
        
        // only if mediaTypes has a value
        if let mediaTypes = mediaTypes {
            imagePicker.mediaTypes = mediaTypes
        }
    }
    @IBAction func decodeSecret(_ sender: Any) {
        guard let image = imageView.image else {
            return
        }
        
        var alertText = "No secret found."
        
        if let secret = image.decodeSecret() {
            alertText = "Secret was: \(secret)"
        }
        
        let alertController = UIAlertController(title: "Secret", message: alertText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alertController, animated: true, completion: {})
    }
    @IBAction func encodeSecret(_ sender: Any) {
        guard let image = imageView.image else {
            return
        }
        
        // get the secret
        let alertController = UIAlertController(title: "Secret", message: "Please input your secret:", preferredStyle: .alert)
        
        // closure that gets fired off when user hits "confirm"
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            guard
                 let secret = alertController.textFields?[0],
                 let text = secret.text,
                 let encodedImage = image.encodeSecret(secret: text),
                 // png because lossless
                 let pngImageData = UIImagePNGRepresentation(encodedImage),
                 let imageToSave = UIImage(data: pngImageData)
            else {
                debugPrint("Failed to get the secret!")
                return
            }
        
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            self.imageView.image = imageToSave
            debugPrint("Successfully saved encoded image.")
        }
        
        // basically do nothing when the user hits cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Secret"
        }
        
        // notice how this is "mutating" even though constant
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        debugPrint("Cancel tapped.")
        imagePicker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true)
        let image = info[UIImagePickerControllerOriginalImage]
        
        if let image = image as? UIImage {
            imageView.image = image
        }
    }

}

