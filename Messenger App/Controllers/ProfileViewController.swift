//
//  ProfileViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class ProfileViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    let data = ["Log Out"]
    override func viewDidLoad() {
          super.viewDidLoad()
          //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
          tableView.delegate = self
          tableView.dataSource = self
          tableView.tableHeaderView = createTableHeader()
          profileImage.layer.cornerRadius = profileImage.frame.width/2
      }
    func createTableHeader() -> UIView? {
           guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
               return nil
           }
        
        let safeEmail = DatabaseManger.safeEmail(emailAddress: email)
               let filename = safeEmail + "_profile_picture.png"
               let path = "images/"+filename
        StorageManager.shared.downloadURL(for: path, completion: {[weak self ] result in
                  switch result {
                  case .success(let url):
                   //   self.profileImage.sd_setImage(with: url, completed: nil)
                      self?.downloadImage(imageView: (self?.profileImage)!, url: url)
                  case .failure(let error):
                      print("Failed to get download url: \(error)")
                  }
              })
        return headerView
  }
    func downloadImage(imageView : UIImageView , url : URL){
        URLSession.shared.dataTask(with: url , completionHandler: {
            data , _ , error in
            guard let data = data , error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                print("success")
                imageView.image = image
            }
        }).resume()
    }
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
