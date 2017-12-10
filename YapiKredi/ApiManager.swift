//
//  ApiManager.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 08/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UIKit
import AFNetworking

let domain                      = "http://10.0.0.144:8000"

let initService                 = "\(domain)/init/"
let sendMoneyToPoolService      = "\(domain)/sendtopool/"
let sendMoneyFromPoolService    = "\(domain)/getfrompool/"
let getPoolBalanceService       = "\(domain)/poolbalance/"
let getCustomerBalanceService   = "\(domain)/getbalance/"
let requestMoneyService         = "\(domain)/requestmoney/"
let pushDecisionService         = "\(domain)/pushdecision/"
let getbillamountService        = "\(domain)/getbillamount/"
let makePaymentService          = "\(domain)/makepayment/"



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
    
    func getBillamountServiceCall( amount: String, completion: @escaping (Any?, Error?) -> Void) {
        
        let dic = NSMutableDictionary()
        dic.setObject(amount, forKey: "product" as NSCopying)
       
        
        self.post(address: getbillamountService, params: dic, completion: completion)
    }
    
    func pushDecisionServiceCall(userId: String, decision: String, completion: @escaping (Any?, Error?) -> Void) {
        
        let dic = NSMutableDictionary()
        dic.setObject(userId, forKey: "clientID" as NSCopying)
        dic.setObject(decision, forKey: "decision" as NSCopying)
        
        self.post(address: pushDecisionService, params: dic, completion: completion)
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

