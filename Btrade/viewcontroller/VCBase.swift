//
//  VCBase.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/01.
//

import Foundation
import UIKit
import SwiftyJSON
import Network
import Alamofire

class VCBase: UIViewController , ApiResult, ProgressInterface{
    var appInfo : APPInfo = APPInfo.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard();
    }
    
    let handler_start = {
        Popup().progressShow()
    }
    
    let handler_complete = {
        Popup().progressDismiss()
    }
    
    let handler_error = {
        Popup().progressDismiss()
    }
    
    
    func startProgress() {
        print("----- startProgress")
        handler_start()
    }
    
    func endProgress() {
        print("----- endProgress")
        handler_complete()
    }
    
    func onResult(response:BaseResponse){
        
    }
    
    func onError(e:AFError, method:String){
        
    }
    
    func showErrorDialog(_ msg : String = "네트워크에 접속할 수 없습니다. 네트워크 연결 상태를 확인해 주세요"){
        DialogUtils().makeDialog(
            uiVC: self,
            message: msg,
            BtradeAlertAction(title: "확 인", style: .default) { (action) in
                
            })
    }
    
    func showErrorDialog(_ msg : String = "네트워크에 접속할 수 없습니다. 네트워크 연결 상태를 확인해 주세요", action:@escaping ((BtradeAlertAction) -> Void)){
        DialogUtils().makeDialog(
            uiVC: self,
            message: msg,
            BtradeAlertAction(title: "확 인", style: .default, handler: action))
    }
    
    class Popup{
        static var popup : Popup? = nil;
        static func getInstance() -> Popup{
            if(popup == nil){
                popup = Popup()
            }
            return popup!
        }
        
        func progressShow(){
            print("----- progressShow")
            DispatchQueue.main.async{ ProgressPopup.show() }
        }
        
        func progressDismiss(){
            DispatchQueue.main.async{ ProgressPopup.hide() }
        }
    }
    
    func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}), let rootViewController = window.rootViewController else {
            return nil
        }

        var topController = rootViewController

        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func showToast(_ message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.5, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIViewController{
    func hideKeyboard(){
        let tap = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
