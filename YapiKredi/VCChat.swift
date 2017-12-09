//
//  VCChat.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 09/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//



import UIKit
import Firebase
import JSQMessagesViewController
import Nuke

class VCChat: JSQMessagesViewController {
    
    let hiddenContainer = UIImageView()
    
    var lastReceivedObiData : String?
    
    private lazy var messageRef: DatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: DatabaseHandle?
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    lazy var obiBubbleImageView     : JSQMessagesBubbleImage =  {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()

    var channelRef: DatabaseReference?
    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(hiddenContainer)
        self.senderId = Auth.auth().currentUser?.uid
        // Do any additional setup after loading the view.
        //collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        //collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        PushHandler.shared.delegate = self
        observeMessages()
        
        self.collectionView.isUserInteractionEnabled = true
        
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        

        finishSendingMessage() // 5
        
        
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        //Nothing
        
    }
    
    private func observeMessages() {
        //messageRef = channelRef!.child("messages")
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }

    // MARK: - CollectioView delegate
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        }
        else if (message.senderId == obiID) {
            return obiBubbleImageView
        }
        else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            return nil
        } else {
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
            
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        //return 17.0
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            return 0.0
        } else {
            
            return 17.0
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        cell.isUserInteractionEnabled = true
        if message.senderId == obiID {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    var images = [UIImage]()
    var ImageCache = [String:UIImage]()
    var imagesURL = [String]()
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let placeHolderImage = #imageLiteral(resourceName: "cemcuk")
        var avatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: placeHolderImage, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        let avatarOwner = messages[indexPath.row].senderId!
        
        if let avatar = ImageCache[avatarOwner] {
            avatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: avatar, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        } else {
            
            getAvatarURL(id: avatarOwner, completion: { (avatarUrl, error) in
                
                guard let avatarURL = avatarUrl, error == nil else {
                    return
                }
                
                Nuke.loadImage(with: avatarURL, into: self.hiddenContainer, handler: { (resultList, status) in
                    
                    if let image = resultList.value {
                        self.ImageCache[avatarOwner] = image
                        
                        avatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
                        self.finishReceivingMessage()
                        
                    }
                    
                })
            })
            

        }
        
        return avatarImage
    }
    

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, at indexPath: IndexPath!) {
        super.collectionView(collectionView, didTapAvatarImageView: avatarImageView, at: indexPath)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        super.collectionView(collectionView, didTapCellAt: indexPath, touchLocation: touchLocation)
        
        let message = messages[indexPath.item]
        
        if message.senderId == obiID, let obiData = lastReceivedObiData {
            NSLog("Pressed on OBI MESSAGE!!")
            
            let amount = obiData
            //
        }
        
    }

    
    // MARK: - UI
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VCChat : PushHandlerDelegate {
    
    func didReceiveNewObiMessage(message: JSQMessage, with: String?) {
//        messages.append(message)
//        self.finishReceivingMessage()
        
        let itemRef = messageRef.childByAutoId() // 1
        
        let messageItem = [ // 2
            "senderId": obiID,
            "senderName": message.senderDisplayName!,
            "text": message.text
            ]
        
        itemRef.setValue(messageItem) // 3
        
        finishSendingMessage() // 5
        
        lastReceivedObiData = with
        
    }
    
}




