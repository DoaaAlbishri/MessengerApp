//
//  RegisterViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    
    
    @IBOutlet weak var fName: UITextField!
    
    @IBOutlet weak var lName: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                    imageView.addGestureRecognizer(tapGR)
                    imageView.isUserInteractionEnabled = true
       // imageView.layer.borderWidth = 2
    }

    @objc func imageTapped(sender: UITapGestureRecognizer) {
    presentPhotoActionSheet()
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        guard let firstName = fName.text ,
              let lastName = lName.text ,
              let email = email.text,
              let password = password.text,
              !firstName.isEmpty ,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty
        else{
        //toasts
            return
        }
        
        DatabaseManger.shared.userExists(with: email, completion : {
           [weak self ] exists in
            
            guard let strongSelf = self else {
                return
            }
            
            guard  !exists  else {
                //user already exists
                
                //alert / toast (p5)
                return
            }
            // Firebase Login / check to see if email is taken
            // try to create an account
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult , error  in
                
                //part 5
                guard authResult != nil , error == nil else {
                    print("Error creating user")
                    return
                }
    //            let user = result.user
    //            print("Created User: \(user)")
                DatabaseManger.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                
                // if this succeeds, dismiss
                //strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Main",bundle: nil)
                let story = storyboard.instantiateViewController(withIdentifier: "chats") as! ConversationViewController
                strongSelf.navigationController?.pushViewController(story, animated: true)
            })
        })
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // get results of user taking picture or selecting from camera roll
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
        
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // take a photo or select a photo
        
        // action sheet - take photo or choose photo
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.imageView.image = selectedImage
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
