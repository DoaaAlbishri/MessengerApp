//
//  ChatViewController.swift
//  Messenger App
//
//  Created by administrator on 05/01/2022.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {

    struct Message : MessageType{
        public var sender: SenderType // sender for each message
        public var messageId: String // id to de duplicate
        public var sentDate: Date // date time
        public var kind: MessageKind // text, photo, video, location, emoji
    }
    // sender model
    struct Sender: SenderType {
        public var photoURL: String // extend with photo URL
        public var senderId: String
        public var displayName: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
