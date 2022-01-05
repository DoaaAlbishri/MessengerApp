//
//  ViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import FirebaseAuth
class ConversationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
                    try FirebaseAuth.Auth.auth().signOut()
                }
                catch {
                }
        //DatabaseManger.shared.test() // call test!
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    func validateAuth(){
        // current user is set automatically when you log a user in
              if FirebaseAuth.Auth.auth().currentUser == nil {
                  // present login view controller
                  let vc = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                  let nav = UINavigationController(rootViewController: vc)
                  nav.modalPresentationStyle = .fullScreen
                  present(nav, animated: false)
                  
              }
          }
}


