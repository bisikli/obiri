//
//  Utilities.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 09/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import FirebaseStorage

import UIKit

let laterColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
let yesColor = UIColor(red: 69/255, green: 214/255, blue: 93/255, alpha: 1)
let noColor = UIColor(red: 238/255, green: 76/255, blue: 108/255, alpha: 1)
let bubleColor = UIColor(red: 231/255, green: 230/255, blue: 236/255, alpha: 1)

let storageRef = Storage.storage().reference()

let obiID : String = "12312312"

internal class Channel {
    internal let id: String
    internal let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

func getAvatarURL(id: String, completion: @escaping (URL?, Error?) -> Void) {
    
    let ref = "avatars/"+id+".jpg"
    let avatarsRef = storageRef.child(ref)
    
    avatarsRef.downloadURL(completion: completion)
    
}


