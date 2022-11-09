//
//  CustomPopup.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/26.
//

import Foundation
import UIKit

class CustomPopup:UIViewController{
    
    var okBtn:BtradeAlertAction?
    var cancelBtn:BtradeAlertAction?
    var popupTitle:String?
    var popupMessage:String?
    
    @IBOutlet weak var backLayout: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    
    @IBOutlet weak var oneOkBtn: UIButton!
    @IBOutlet weak var twoOkBtn: UIButton!
    @IBOutlet weak var twoCancelBtn: UIButton!
    @IBOutlet weak var oneHeight: NSLayoutConstraint!
    @IBOutlet weak var twoHeight: NSLayoutConstraint!
    
    var btnStatus = "one"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        setValue()
    }
    
    fileprivate func initLayout(){
        backLayout.clipsToBounds = true
        backLayout.layer.cornerRadius = 30
        backLayout.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        oneOkBtn.isUserInteractionEnabled = true
        oneOkBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        twoOkBtn.isUserInteractionEnabled = true
        twoOkBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        twoCancelBtn.isUserInteractionEnabled = true
        twoCancelBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
    }
    
    @objc func selectedTab(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            self.dismiss(animated: true)
        }else if(sender.view == twoCancelBtn){
            self.dismiss(animated: true)
            if let d = cancelBtn?.handler{
                d(cancelBtn!)
            }
        }else if(sender.view == twoOkBtn){
            self.dismiss(animated: true)
            if let d = okBtn?.handler{
                d(okBtn!)
            }
        }else if(sender.view == oneOkBtn){
            self.dismiss(animated: true)
            if let d = okBtn?.handler{
                d(okBtn!)
            }
        }
    }
    
    
    fileprivate func setValue(){
        if let t = popupTitle{
            titleText.text = t
        }
        if let m = popupMessage{
            messageText.text = m
        }
        
        if btnStatus == "two"{
            oneHeight.constant = 0
            oneOkBtn.setTitle("", for: .normal)
            if let ok = okBtn{
                if let t = ok.title{
                    twoOkBtn.setTitle(t, for: .normal)
                }
            }
            if let ok = cancelBtn{
                if let t = ok.title{
                    twoCancelBtn.setTitle(t, for: .normal)
                }
            }
        }else{
            twoHeight.constant = 0
            twoOkBtn.setTitle("", for: .normal)
            twoCancelBtn.setTitle("", for: .normal)
            if let ok = okBtn{
                if let t = ok.title{
                    oneOkBtn.setTitle(t, for: .normal)
                }
            }
        }
        
    }
    
}

class BtradeAlertAction{
    var title: String?
    var style: UIAlertAction.Style
    var handler: ((BtradeAlertAction) -> Void)?
    init(title: String?, style: UIAlertAction.Style, handler: ((BtradeAlertAction) -> Void)? = nil){
        self.title = title
        self.style = style
        self.handler = handler
        print("!!!!!!!!!!!!!!!!!")
    }
}
