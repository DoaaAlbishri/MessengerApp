//
//  NewConversationViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import JGProgressHUD
class NewConversationViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
    }
    
}

extension NewConversationViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("hi")
    }
    // nav back to chats 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        self.navigationController?.dismiss(animated: true, completion: nil)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "chats") as! ConversationViewController
//        navigationController?.present(vc, animated: true, completion: nil)
    }
}
