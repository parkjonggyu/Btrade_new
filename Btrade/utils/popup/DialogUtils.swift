//
//  DialogUtils.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/04.
//

import Foundation
import UIKit

class DialogUtils{
    
    
    // Alert Dialog 생성
    func makeDialog(uiVC:UIViewController, title: String = "알 림", message: String, _ alertOkBtn : BtradeAlertAction? = nil) {
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "CustomPopup") as? CustomPopup else {
            return
        }
        vc.popupTitle = title
        vc.popupMessage = message
        vc.okBtn = alertOkBtn
        if alertOkBtn == nil{
            vc.okBtn = BtradeAlertAction(title: "확 인", style: .default)
        }
        vc.btnStatus = "one"
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        uiVC.present(vc, animated: true);
        
    }
    
    func makeDialog(uiVC:UIViewController, title: String, message: String, _ alertOkBtn : BtradeAlertAction, _ alertCancelBtn : BtradeAlertAction) {
       let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "CustomPopup") as? CustomPopup else {
            return
        }
        vc.popupTitle = title
        vc.popupMessage = message
        vc.okBtn = alertOkBtn
        vc.cancelBtn = alertCancelBtn
        vc.btnStatus = "two"
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        uiVC.present(vc, animated: true);
    }
}
