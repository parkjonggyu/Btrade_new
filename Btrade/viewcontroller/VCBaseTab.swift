//
//  VCBaseTab.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/18.
//

import Foundation
import UIKit
import Alamofire

class VCBaseTab: UITabBarController, UITabBarControllerDelegate , ApiResult, ProgressInterface{
    var appInfo : APPInfo = APPInfo.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

