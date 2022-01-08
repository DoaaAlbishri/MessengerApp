//
//  ViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationViewController: UIViewController {
    
    @IBAction func ComposeButton(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "newChat") as! NewConversationViewController
        print("yes")
        vc.completion = { [weak self] result in
            print(result)
            self?.createNewConversation(result: result)
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var label: UILabel!
    
    private let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //DatabaseManger.shared.test() // call test!
       tableView.delegate = self
       tableView.dataSource = self
       fetchConversations()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func createNewConversation(result: [String:String]) {
        guard let name = result["name"] , let email = result["email"] else {
            return
        }
        let vc = ChatViewController(with: email)
        vc.isNewConversation = true
                   vc.title = name
                   vc.navigationItem.largeTitleDisplayMode = .never
                   navigationController?.pushViewController(vc, animated: true)
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
    private func fetchConversations(){
          // fetch from firebase and either show table or label
          tableView.isHidden = false
      }
  }

  extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
      }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "chatsCell", for: indexPath)
          cell.textLabel?.text = "Hello World"
          cell.accessoryType = .disclosureIndicator
          return cell
      }
      
      // when user taps on a cell, we want to push the chat screen onto the stack
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          
          let vc = ChatViewController(with:"email")
          vc.title = "Jenny Smith"
          vc.navigationItem.largeTitleDisplayMode = .never
          navigationController?.pushViewController(vc, animated: true)
      }
  }


