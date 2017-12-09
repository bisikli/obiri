//
//  PushHandler.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 09/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UIKit
import UserNotifications
import JSQMessagesViewController

public protocol PushHandlerDelegate : NSObjectProtocol {
    func didReceiveNewObiMessage(message: JSQMessage)
}

class PushHandler: NSObject {
    
    static let shared: PushHandler = PushHandler()
    
    var delegate: PushHandlerDelegate? = nil
    
    func receivePush(notif: UNNotification ){
        
        guard let params = notif.request.content.userInfo["obiData"] as? [String:Any] else {
            return
        }
        
        
        
        
    }
    
    func addTestMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            
            if let uwDelegate = delegate {
                uwDelegate.didReceiveNewObiMessage(message: message)
            }
            
        }
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            
            if let uwDelegate = delegate {
                uwDelegate.didReceiveNewObiMessage(message: message)
            }
            
        }
    }

}
