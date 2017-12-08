//
//  AppDelegateNotification.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 08/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UserNotifications
import Firebase
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        NSLog("FIREBASE REMOTE MESSAGE")
        //handlePush(userInfo: remoteMessage.appData, window: window)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("FIREBASE REMOTE MESSAGE REFRESH \(fcmToken)")
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        NSLog("FIREBASE RECEIVED: \(remoteMessage.appData)")
        //handlePush(userInfo: remoteMessage.appData, window: window)
    }
    
    @available(iOS 10.0, *) 
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        //handlePush(userInfo: response.notification.request.content.userInfo, window: window)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        
        
        completionHandler([.alert,.sound])
        
    }
    
}
