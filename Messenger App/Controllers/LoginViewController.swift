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
            showToast(controller: self, message : "Fill all the filed please", seconds: 2.0)
            return
        }
        // Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(email)")
                strongSelf.showToast(controller: strongSelf, message : "The email or password is not correct", seconds: 2.0)
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            // if this succeeds, dismiss
            strongSelf.navigationController?.dismiss(animated: true)
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

}
