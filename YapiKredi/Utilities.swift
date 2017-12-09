//
//  Utilities.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 09/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import FirebaseStorage
import GradientCircularProgress
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

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
}

extension UIView {
    
    func subview(tag: Int) -> UIView? {
        
        for view in self.subviews {
            if(view.tag == tag){
                return view
            }
        }
        return nil
    }
    
    func showLoader() {
        
        let progress = GradientCircularProgress()
        let progressView = progress.show(frame: self.frame, message: "Loading...", style: MyStyle())
        progressView?.tag = 998
        self.addSubview(progressView!)
        self.bringSubview(toFront: progressView!)
        
        
    }
    
    func showLoader(expireAfter: Double){
        
        showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now()+expireAfter) {
            self.hideLoader()
        }
        
    }
    
    func hideLoader() {
        
        
        
        guard let progressView = self.subview(tag: 998) else {
            return
        }
        
        progressView.removeFromSuperview()
        
    }
    
}

public struct MyStyle : StyleProperty {
    /*** style properties **********************************************************************************/
    
    // Progress Size
    public var progressSize: CGFloat = 80
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 9.0
    public var startArcColor: UIColor = UIColor.clear
    public var endArcColor: UIColor = .blue
    
    // Base Circular
    public var baseLineWidth: CGFloat? = 9.5
    public var baseArcColor: UIColor? = UIColor.white
    
    // Ratio
    public var ratioLabelFont: UIFont? = UIFont(name: "Verdana-Bold", size: 8.0)
    public var ratioLabelFontColor: UIColor? = UIColor.white
    
    // Message
    public var messageLabelFont: UIFont? = UIFont.systemFont(ofSize: 10.0)
    public var messageLabelFontColor: UIColor? = .blue
    
    // Background
    public var backgroundStyle: BackgroundStyles = .none
    
    // Dismiss
    public var dismissTimeInterval: Double? = 0.0 // 'nil' for default setting.
    
    /*** style properties **********************************************************************************/
    
    public init() {}
}


