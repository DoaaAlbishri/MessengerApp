//
//  ChatViewController.swift
//  Messenger App
//
//  Created by administrator on 05/01/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
class ChatViewController: MessagesViewController {
    
    public var isNewConversation = false
    public let otherUserEmail: String
    private var messages = [Message]()

    let selfSender = Sender(photoURL: "", senderId: "1", displayName: "new account")
    
       init(with email: String) {
           //self.conversationId = id
           self.otherUserEmail = email
           super.init(nibName: nil, bundle: nil)
           // creating a new conversation, there is no identifier
           
       }

    required init?(coder: NSCoder) {
        fatalError("init    (coder:) has not been implemented")
    }
    
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
        view.backgroundColor = .green
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           messageInputBar.inputTextView.becomeFirstResponder()
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        }
        // Send message
        if isNewConversation {
            // create convo in database
            // message ID should be a unique ID for the given message, unique for all the message

        }else {
        
            
        }
        
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
        
        func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
            return messages[indexPath.section] // message kit framework uses section to separate every single message
            // a message on screen might have mulitple pieces (cleaner to have a single section per message)
        }
        
        func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
            messages.count
        }
        
        
    
}

