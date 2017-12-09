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
    func didReceiveNewObiMessage(message: JSQMessage, with params: String?)
}

class PushHandler: NSObject {
    
    static let shared: PushHandler = PushHandler()
    
    var delegate: PushHandlerDelegate? = nil
    
    func receivePush(notif: UNNotification ){
        
        let params = notif.request.content.userInfo
        
        guard let isObiData = params["gcm.notification.obidata"] as? String else {
            return
        }
        
        if let id = params["gcm.notification.id"] as? String, let message = params["gcm.notification.message"] as? String, let name = params["gcm.notification.name"] as? String {
            
            
            
            addMessage(withId: id, name: name, text: message, params: params["gcm.notification.amount"] as? String)
            
        }
        
        
        
    }
    
//    func addTestMessage(withId id: String, name: String, text: String) {
//        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
//
//            if let uwDelegate = delegate {
//                uwDelegate.didReceiveNewObiMessage(message: message)
//            }
//
//        }
//    }
    
    private func addMessage(withId id: String, name: String, text: String, params: String?) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            
            if let uwDelegate = delegate {
                uwDelegate.didReceiveNewObiMessage(message: message, with: params)
            }
            
        }
    }

}
