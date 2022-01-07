//
//  RegisterViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
class RegisterViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)

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
//        imageView.layer.borderWidth = 2
//        imageView.layer.cornerRadius = 100
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
            showToast(controller: self, message : "Fill all the filed please", seconds: 2.0)
            return
        }
        spinner.show(in: view)
        
        DatabaseManger.shared.userExists(with: email, completion : {
           [weak self ] exists in
            
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()

            }
            guard  !exists  else {
                //user already exists
                strongSelf.showToast(controller: strongSelf, message : "user already exists", seconds: 2.0)
                return
            }
            
            // Firebase Login / check to see if email is taken
            // try to create an account
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult , error  in
                
                //part 5
                guard authResult != nil , error == nil else {
                    print("Error creating user")
                    strongSelf.showToast(controller: strongSelf, message : "The account has not been created", seconds: 2.0)
                    return
                }
    //            let user = result.user
    //            print("Created User: \(user)")
                
                let ChatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManger.shared.insertUser(with: ChatUser , completion: {
                    success in
                    if success {
                        // upload image
                        guard let image = strongSelf.imageView.image , let data =  image.pngData() else{
                            return
                        }
                        let fileName = ChatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: {
                            result in
                            switch result {
                            case .success(let downloadUrl) : print(downloadUrl)
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_pic_url")
                            case .failure(let error) : print("Storge manger error \(error)")
                            }
                        })
                    }
                })
                
                // if this succeeds, dismiss
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
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
