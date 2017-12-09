//
//  ApiManager.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 08/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UIKit
import AFNetworking

let initService                 = "http://10.0.1.37:8000/init/"
let sendMoneyToPoolService      = "http://10.0.1.37:8000/sendtopool/"
let sendMoneyFromPoolService    = "http://10.0.1.37:8000/getfrompool/"
let getPoolBalanceService       = "http://10.0.1.37:8000/poolbalance/"
let getCustomerBalanceService   = "http://10.0.1.37:8000/getbalance/"
let requestMoneyService         = "http://10.0.1.37:8000/requestmoney/"

class ApiManager: NSObject {
    
    static let manager = ApiManager()
    
    func post(address: String, params: NSDictionary, completion: @escaping (_ result:Any?, _ error: Error?)-> Void){
        

        let manager = AFHTTPSessionManager()
        
        manager.requestSerializer = AFJSONRequestSerializer()
        
        manager.post(address, parameters: params, progress: { (progress) in
            //mmaLogger(string:"Request progress: \(progress)")
        }, success: { (operation, responseObject) in
        
            completion(responseObject, nil)
        
        }) { (operation, error) in
            print("Error post! \(error.localizedDescription)")
            completion(nil, error)
        }
        
        
    }
    
    
    func requestMoneyServiceCall(userId: String, amount: String, completion: @escaping (Any?, Error?) -> Void) {
        
        let dic = NSMutableDictionary()
        dic.setObject(userId, forKey: "clientID" as NSCopying)
        dic.setObject(Int(amount)!, forKey: "amount" as NSCopying)
        
        self.post(address: requestMoneyService, params: dic, completion: completion)
    }
    
    func initServiceCall(userId: String, token: String, completion: @escaping (Any?, Error?) -> Void){
        
        let dic = NSMutableDictionary()
        dic.setObject(userId, forKey: "clientID" as NSCopying)
        dic.setObject(token, forKey: "pushToken" as NSCopying)
        
        self.post(address: initService, params: dic, completion: completion)
        
    }
    
    func sendMoneyToPoolServiceCall(userId: String, amount: String, completion: @escaping (Any?, Error?) -> Void){
        
        let dic = NSMutableDictionary()
        dic.setObject(userId, forKey: "clientID" as NSCopying)
        dic.setObject(amount, forKey: "amount" as NSCopying)
        
        self.post(address: sendMoneyToPoolService, params: dic, completion: completion)
        
    }
    
    func sendMoneyFromPoolServiceCall(userId: String, amount: String, completion: @escaping (Any?, Error?) -> Void){
        
        let dic = NSMutableDictionary()
        dic.setObject(userId, forKey: "clientID" as NSCopying)
        dic.setObject(amount, forKey: "amount" as NSCopying)
        
        self.post(address: sendMoneyFromPoolService, params: dic, completion: completion)
        
    }
    
    func getPoolBalanceServiceCall(completion: @escaping (_ result:Any?, _ error: Error?)-> Void) {
        
        let manager = AFHTTPSessionManager()
        
        manager.requestSerializer = AFJSONRequestSerializer()
        
        manager.get(getPoolBalanceService, parameters: [], progress: { (progress) in
            
        }, success: { (operation, responseObject) in
            
            completion(responseObject, nil)
            
        }) { (operation, error) in
            print("Error get! \(error.localizedDescription)")
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

