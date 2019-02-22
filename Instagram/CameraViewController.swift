//
//  CameraViewController.swift
//  Instagram
//
//  Created by Tobi Ola on 2/17/19.
//  Copyright © 2019 Tobi Ola. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase
import FirebaseStorage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func onSubmitButton(_ sender: Any) {
        print("submitting")
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser!


        let caption = commentField.text!

        
        let imageData = imageView.image!.pngData()
        let imagesRef = Storage.storage().reference().child(user.uid + "/" + Date().description)
        
        if imageData == nil {
            return
        }
        
        let data = Data(imageData!)
        
        
        imagesRef.putData(data, metadata: nil) { (metadata, error) in
                imagesRef.downloadURL{ (url, error) in
                    guard let downloadUrl = url?.absoluteString else {
                        print("err mess")
                        return
                    }
                    
                        db.collection("posts").addDocument(data: [
                            "url" : downloadUrl,
                            "author" : Auth.auth().currentUser?.displayName ?? "user_404",
                            "caption" : caption
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added")
                            }
                        }
                    
                }
                print("there is an error")
        }
        
        
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
                
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
