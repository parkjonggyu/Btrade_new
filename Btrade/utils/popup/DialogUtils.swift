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
    func makeDialog(uiVC:UIViewController, title: String = "알 림", message: String, _ alertOkBtn : UIAlertAction? = nil) {

        // alert : 가운데에서 출력되는 Dialog. 취소/동의 같이 2개 이하를 선택할 경우 사용. 간단명료 해야함.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let action = alertOkBtn{
            alert.addAction(action)
        }else{
            alert.addAction(UIAlertAction(title: "확 인", style: .default))
        }
        uiVC.present(alert, animated: true, completion: nil)
    }
    
    func makeDialog(uiVC:UIViewController, title: String, message: String, _ alertOkBtn : UIAlertAction, _ alertCancelBtn : UIAlertAction) {

        // alert : 가운데에서 출력되는 Dialog. 취소/동의 같이 2개 이하를 선택할 경우 사용. 간단명료 해야함.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(alertOkBtn)
        alert.addAction(alertCancelBtn)
        uiVC.present(alert, animated: true, completion: nil)
    }
}
