//
//  LoginViewController.swift
//  Instagram
//
//  Created by Tobi Ola on 2/18/19.
//  Copyright © 2019 Tobi Ola. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if error == nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("u messed up buddy")
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        let displayName = email.components(separatedBy: "@")[0]

        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
                Auth.auth().signIn(withEmail: email, password: password, completion: { (data, error) in
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = displayName
                    changeRequest?.commitChanges { (error) in
self.performSegue(withIdentifier: "loginSegue", sender: nil)                    }
                    
                    
                    
                    
                })

        }
        
        
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
