//
//  VCChatContainer.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 09/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UIKit
import Firebase

class VCChatContainer: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var vcContainer: UIView!
    
    @IBOutlet weak var havuzBalance: UILabel!
    
    var senderDisplayName: String?
    var channel : Channel?
    var channelRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignResponder)))
        
        pollPoolBalance()
        
        // Do any additional setup after loading the view.
    }
    
    func pollPoolBalance(){
        
        ApiManager.manager.getPoolBalanceServiceCall { (result, error) in
            
            if(error != nil){
                
            }else{
                
                if let data = result as? [String:Any], let balance = data["balance"] as? String {
                    
                    DispatchQueue.main.async {
                        self.havuzBalance.text = balance
                    }
                    
                }
                //success , balance
                
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            
            self.pollPoolBalance()
            
        }
        
    }

    @objc func resignResponder(){
        
        if let chatVC = self.childViewControllers.last as? VCChat {
            
            chatVC.view.endEditing(true)
            
        }
    
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

            let chatVc = segue.destination as! VCChat
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel           = channel
            chatVc.channelRef        = channelRef
    
        
    }

}
