//
//  VCBaseNavi.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/07.
//

import Foundation
import UIKit
import Alamofire

class VCBaseNavi: UINavigationController , ApiResult, ProgressInterface{
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
