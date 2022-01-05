//
//  NewConversationViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit

class NewConversationViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension NewConversationViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
