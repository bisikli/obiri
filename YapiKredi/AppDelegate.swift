//
//  AppDelegate.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 08/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseAuthUI
import FirebaseGoogleAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.applicationIconBadgeNumber = 0
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    
                    
                    
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        
        application.registerForRemoteNotifications()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
//                                               name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        
       
        
        guard (Auth.auth().currentUser != nil) else {
            
            let authUI = FUIAuth.defaultAuthUI()
            authUI?.delegate = self
            let providers: [FUIAuthProvider] = [
                FUIGoogleAuth()
            ]
            authUI?.providers = providers
            
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = authUI?.authViewController()
            return true
            
        }
        
        if let userId = Auth.auth().currentUser?.uid, let token = Messaging.messaging().fcmToken {
            
            NSLog("FCM token: \(token)")
            NSLog("USER ID: \(userId)")
            
            ApiManager.manager.initServiceCall(userId: userId, token: token, completion: { (result, error) in
                
                if let data = result as? [String:Any], let success = data["success"] as? String {
                    
                }
                
            })
            
        }
        
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10) {
//
//            PushHandler.shared.addTestMessage(withId: obiID, name: "Obi", text: "Obi says hello!")
//
//        }
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
        guard let navigationController: UINavigationController =
            storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController else {
            return
        }
        
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = navigationController
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        
        return VCFirebaseSignIn(nibName: "VCFirebaseSignIn",
                                bundle: Bundle.main,
                                authUI: authUI)
        
    }
    
    
    
    
}


