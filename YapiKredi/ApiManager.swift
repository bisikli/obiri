//
//  ApiManager.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 08/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UIKit
import AFNetworking

class ApiManager: NSObject {

    
    func downloader(address: String, params: NSDictionary, completion: @escaping (_ result:Any?, _ error: Error?)-> Void){
        
        
        
        let manager = AFHTTPSessionManager()
        
        manager.post(address, parameters: params, progress: { (progress) in
            //mmaLogger(string:"Request progress: \(progress)")
        }, success: { (operation, responseObject) in
        
            completion(responseObject, nil)
        
        }) { (operation, error) in
            
            completion(nil, error)
        }
        
        
    }
    
    
}


//params.setValue(accessToken, forKey: "accessToken")
//
//
//let manager = AFHTTPSessionManager()
//
//manager.post(eventService, parameters: params, progress: { (progress) in
//    mmaLogger(string:"Request progress: \(progress)")
//}, success: { (operation, responseObject) in
//
//    completion(responseObject as? [AnyHashable : Any], nil)
//
//}) { (operation, error) in
//    mmaLogger(string:error.localizedDescription)
//    completion(nil, error)
//}

