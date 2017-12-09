//
//  Utilities.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 09/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import FirebaseStorage

let storageRef = Storage.storage().reference()

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


