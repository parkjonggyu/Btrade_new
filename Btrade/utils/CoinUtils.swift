//
//  CoinUtils.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/08.
//

import Foundation


class CoinUtils{
    
    static func getlevel(_ memberInfo:MemberInfo) -> Int{
        let certify_email = memberInfo.certify_email
        let aml_state = memberInfo.aml_state
        var certify_otp = memberInfo.certify_otp
        
        let certify_lever:Int = 1
        if(certify_email == nil || aml_state == nil){
            return certify_lever
        }
        if(certify_otp == nil){certify_otp = "N"}
        
        if(certify_email == "Y" && aml_state == "cc" && certify_otp == "Y"){
            return 3
        }else if(certify_email == "Y" && aml_state == "cc"){
            return 2
        }else{
            return 1
        }
    }
}
