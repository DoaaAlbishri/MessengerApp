//
//  DatabaseManager.swift
//  Messenger App
//
//  Created by administrator on 04/01/2022.
//

import Foundation
import FirebaseDatabase
// singleton creation below
// final - cannot be subclassed
final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    // reference the database below
    
    private let database = Database.database().reference()
    
    // create a simple write function
    public func test() {
        // NoSQL - JSON (keys and objects)
        // child refers to a key that we want to write data to
        // in JSON, we can point it to anything that JSON supports - String, another object
        // for users, we might want a key that is the user's email address
        
        database.child("foo").setValue(["something":true])
    }
    static func safeEmail(emailAddress: String) -> String {
          var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
          safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
          return safeEmail
      }
}

// MARK: - account management
extension DatabaseManger {
    
    // have a completion handler because the function to get data out of the database is asynchrounous so we need a completion block
    
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
        // will return true if the user email does not exist
        
        // firebase allows you to observe value changes on any entry in your NoSQL database by specifying the child you want to observe for, and what type of observation you want
        // let's observe a single event (query the database once)
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            // snapshot has a value property that can be optional if it doesn't exist
            
            guard snapshot.value as? String != nil else {
                // otherwise... let's create the account
                completion(false)
                return
            }
            
            // if we are able to do this, that means the email exists already!
            
            completion(true) // the caller knows the email exists already
        }
    }
    
    /// Insert new user to database
    public func insertUser(with user: ChatAppUser , completion: @escaping (Bool) -> Void ){
        database.child(user.safeEmail).setValue(["first_name":user.firstName,"last_name":user.lastName], withCompletionBlock: { [weak self] error , _ in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else{
                print("Failed to write to database")
                completion(false)
                return
            }
           
            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)

                    strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
                else {
                    // create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]

                    strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
            })
        })
    }
    /// Gets all users from database
      public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
          database.child("users").observeSingleEvent(of: .value, with: { snapshot in
              guard let value = snapshot.value as? [[String: String]] else {
                  completion(.failure(DatabaseError.failedToFetch))
                  return
              }

              completion(.success(value))
          })
      }

      public enum DatabaseError: Error {
          case failedToFetch

          public var localizedDescription: String {
              switch self {
              case .failedToFetch:
                  return "This means blah failed"
              }
          }
      }
}
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    var profilePictureFileName: String {
        //jmh3434-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
    
    // create a computed property safe email
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
