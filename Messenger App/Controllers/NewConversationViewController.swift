//
//  NewConversationViewController.swift
//  Messenger App
//
//  Created by admin on 29/12/2021.
//

import UIKit
import JGProgressHUD


struct SearchResult {
    let name: String
    let email: String
}

class NewConversationViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
  
    public var completion: ((SearchResult) -> (Void))?

    private var users = [[String: String]]()

    private var results = [[String:String]]()

    private var hasFetched = false
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell",
                                                 for: indexPath) //as! NewConversationCell
        //cell.configure(with: model)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        // start conversation
//        let targetUserData = results[indexPath.row]
//
//        dismiss(animated: true, completion: { [weak self] in
//            self?.completion?(targetUserData)
//        })
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension NewConversationViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("hi")
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
             return
         }

         searchBar.resignFirstResponder()

         results.removeAll()
         spinner.show(in: view)

         searchUsers(query: text)
    }
    // nav back to chats 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    func searchUsers(query: String) {
          // check if array has firebase results
          if hasFetched {
              // if it does: filter
              filterUsers(with: query)
          }
          else {
              // if not, fetch then filter
              DatabaseManger.shared.getAllUsers(completion: { [weak self] result in
                  switch result {
                  case .success(let usersCollection):
                      self?.hasFetched = true
                      self?.users = usersCollection
                      self?.filterUsers(with: query)
                  case .failure(let error):
                      print("Failed to get usres: \(error)")
                  }
              })
          }
    }
    ///filterUsers
    func filterUsers(with term: String) {
          // update the UI: eitehr show results or show no results label
          guard hasFetched else {
              return
          }

          self.spinner.dismiss()

        let results: [[String:String]] = users.filter({

              guard let name = $0["name"]?.lowercased() else {
                  return false
              }

              return name.hasPrefix(term.lowercased())
          })

          self.results = results

          updateUI()
      }

      func updateUI() {
          if results.isEmpty {
              label.isHidden = false
              tableView.isHidden = true
          }
          else {
              label.isHidden = true
              tableView.isHidden = false
              tableView.reloadData()
          }
      }

    
}
