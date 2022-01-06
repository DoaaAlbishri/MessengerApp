//
//  ProfileViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
class ProfileViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let data = ["Log Out"]
    override func viewDidLoad() {
          super.viewDidLoad()
          //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
          tableView.delegate = self
          tableView.dataSource = self
//        tableView.tableHeaderView = createTableHeader()
      }
//    func createTableHeader() -> UIView? {
//           guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//               return nil
//           }
//        //let view = UIView()
//        rerturn nil
//  }
}
  extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return data.count
      }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          cell.textLabel?.text = data[indexPath.row]
          cell.textLabel?.textAlignment = .center
          cell.textLabel?.textColor = .red
          return cell
      }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true) // unhighlight the cell
          // logout the user
          
          // show alert
          
          let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
          
          actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
              // action that is fired once selected
              
              guard let strongSelf = self else {
                  return
              }
              
            
              
              do {
                  try FirebaseAuth.Auth.auth().signOut()
                  
                  // present login view controller
                  let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                  let nav = UINavigationController(rootViewController: vc)
                  nav.modalPresentationStyle = .fullScreen
                  strongSelf.present(nav, animated: true)
              }
              catch {
                  print("failed to logout")
              }
              
          }))
          
          actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
          present(actionSheet, animated: true)
      }
      
  }
