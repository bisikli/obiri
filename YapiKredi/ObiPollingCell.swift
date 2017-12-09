//
//  ObiPollingCell.swift
//  YapiKredi
//
//  Created by Bilgehan IŞIKLI on 09/12/2017.
//  Copyright © 2017 BY. All rights reserved.
//

import UIKit
import SnapKit
import JSQMessagesViewController

enum ObiButtonType {
    case YES
    case NO
    case LATER
}

public protocol ObiPollingCellDelegate : NSObjectProtocol {
    func didYesButtonPressed(extra: String)
    func didNoButtonPressed()
    func didLaterButtonPressed()
}

class ObiPollingCell: JSQMediaItem {

    var delegate: ObiPollingCellDelegate?
    
        private var textView:UILabel!
        private var yesButton:UIButton!
        private var noButton:UIButton!
        private var laterButton:UIButton!
        private var size:CGSize!
        private var cachedMessageImageView:UIImageView?
        private var extra:String!
        
        //----------------------------------------------//
        init(text:String, extra: String) {
            //----------------------------------------------//
            textView = UILabel()
            
            yesButton = UIButton()
            noButton  = UIButton()
            laterButton = UIButton()
            
            super.init(maskAsOutgoing: false)
            cachedMessageImageView = nil
            
            self.extra = extra
            textView.text = text
            
            setTextView()
            prepareForCellLoad()
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit{
            
            textView = nil
            yesButton = nil
            noButton = nil
            size = nil
            
            self.cachedMessageImageView = nil
        }
        
        override func mediaView() -> UIView! {
            return cachedMessageImageView
        }
        
        override func mediaViewDisplaySize() -> CGSize {
            return size!
        }
    
        private func setTextView(){
            let max_Width = 0.7 * UIScreen.main.bounds.width
            
            textView.frame = CGRect(x:10, y: 10, width: max_Width, height: 0)
            textView.font = UIFont(name: "Helvetica", size: 17.0)
            textView.backgroundColor = UIColor.clear
            textView.sizeToFit()
     
            let textView_Width =  min(max_Width,max(textView.frame.size.width, 45))
            
            size =  CGSize(width: textView_Width + 30, height: textView.frame.size.height + 60)
            
            
            
            var autoResizing:UIViewAutoresizing?
            
            
            
            textView.frame = CGRect(x: 15, y: 10, width: size!.width - 30, height: textView.frame.size.height)
            autoResizing = UIViewAutoresizing.flexibleRightMargin
            
            textView.autoresizingMask = autoResizing!
            
            yesButton.layer.cornerRadius = 10.0
            yesButton.backgroundColor = yesColor
            yesButton.titleLabel?.textColor = .black
            yesButton.frame = CGRect(x: 15, y: textView.bounds.maxY + 15, width: (size.width-30)/3, height: size.height-textView.frame.size.height-25)
            yesButton.setTitleColor(.white, for: .normal)
            yesButton.setTitle("EVET", for: .normal)
            yesButton.titleLabel?.font =  UIFont(name: "Helvetica", size: 14.0)
            
            noButton.layer.cornerRadius = 10.0
            noButton.backgroundColor = noColor
            noButton.setTitleColor(.white, for: .normal)
            noButton.frame = CGRect(x: yesButton.bounds.maxX+17.75, y: textView.bounds.maxY + 15, width: (size.width-30)/3, height: size.height-textView.frame.size.height-25)
            noButton.setTitle("HAYIR", for: .normal)
            noButton.titleLabel?.font =  UIFont(name: "Helvetica", size: 14.0)
            
            laterButton.layer.cornerRadius = 10.0
            laterButton.backgroundColor = laterColor
            laterButton.setTitleColor(.white, for: .normal)
            laterButton.frame = CGRect(x: yesButton.bounds.maxX+noButton.bounds.size.width+20, y: textView.bounds.maxY + 15, width: (size.width-30)/3, height: size.height-textView.frame.size.height-25)
            laterButton.setTitle("SONRA", for: .normal)
            laterButton.titleLabel?.font =  UIFont(name: "Helvetica", size: 14.0)
            
            yesButton.isUserInteractionEnabled      = true
            noButton.isUserInteractionEnabled       = true
            laterButton.isUserInteractionEnabled    = true
            
            yesButton.addTarget(self, action: #selector(yesSelected), for: UIControlEvents.touchUpInside)
            noButton.addTarget(self, action: #selector(noSelected), for: UIControlEvents.touchUpInside)
            laterButton.addTarget(self, action: #selector(laterSelected), for: UIControlEvents.touchUpInside)
            
        }
    
    @objc func yesSelected(){
        
        if let del = self.delegate {
            del.didYesButtonPressed(extra: self.extra)
        }
        
    }
    
    @objc func noSelected(){
        
        if let del = self.delegate {
            del.didNoButtonPressed()
        }
        
    }
    
    @objc func laterSelected(){
        
        if let del = self.delegate {
            del.didLaterButtonPressed()        }
        
    }
        
        private func prepareForCellLoad(){
            
            
            let colorBackGround:UIColor = bubleColor

            
            let imgView:UIImageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: size!.width, height: size!.height))
            
            imgView.backgroundColor = colorBackGround
            imgView.clipsToBounds = true
            imgView.addSubview(textView)
            imgView.addSubview(yesButton)
            imgView.addSubview(noButton)
            imgView.addSubview(laterButton)
            
            

            imgView.autoresizingMask = textView.autoresizingMask
            JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: imgView, isOutgoing: false)
            imgView.isUserInteractionEnabled = true
            cachedMessageImageView = imgView
        }
        
    
        
        
        
        
        private func isSingleLine() ->Bool {
            let textView_height = textView.frame.size.height
            let textView_width = textView.frame.size.width
            let view_width = size!.width
            return (textView_height <= 65 && textView_width <= 0.7 * view_width)
        }
        
        
        
      
        
        func getText() -> String{
            return self.textView.text!
        }
        
        
        
}
