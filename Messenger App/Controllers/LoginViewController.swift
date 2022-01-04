//
//  LoginViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    

    @IBOutlet weak var password: UITextField!
    

    
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = email.text,
              let password = password.text,
              !email.isEmpty,
              !password.isEmpty
        else{
        //toasts
            return
        }
        // Firebase Login
        // Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(email)")
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            // if this succeeds, dismiss
            strongSelf.navigationController?.popToRootViewController(animated: true)
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
