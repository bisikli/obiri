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
    
    var senderDisplayName: String?
    var channel : Channel?
    var channelRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignResponder)))
        
        // Do any additional setup after loading the view.
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
