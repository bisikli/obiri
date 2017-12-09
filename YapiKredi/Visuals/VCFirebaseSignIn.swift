//
//  VCFirebaseSignIn.swift
//  VideoKido
//
//  Created by Bilgehan IŞIKLI on 29/11/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import SnapKit

class VCFirebaseSignIn: FUIAuthPickerViewController {
    
    let logo = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //logo.image = #imageLiteral(resourceName: "defaultPreview")
        view.addSubview(logo)
        logo.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.view).offset(50)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).dividedBy(2.0)
            make.height.equalTo(self.logo.snp.width)
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
