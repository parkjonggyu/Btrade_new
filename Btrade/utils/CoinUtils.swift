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
    
    static func currency(_ i:Int) -> String{
        return currency(String(i), 3)
    }
    
    static func currency(_ s:String) -> String{
        return currency(s, 3)
    }
    
    static func currency(_ v:String,_ c:Int) -> String{
        var cipher = c
        var number = v.replacingOccurrences(of: ",", with: "")
        var strSymbol = ""
        var result = ""
        
        number = number.components(separatedBy: ".")[0]
        
        if((DoubleDecimalUtils.newInstance(number) as NSDecimalNumber).doubleValue < 0){
            strSymbol = "-"
            number = String(abs((DoubleDecimalUtils.newInstance(number) as NSDecimalNumber).doubleValue))
        }
        
        cipher = cipher > 0 ? cipher : 3
        
        let len = number.count
        var nIndex = len % cipher
        let nMax = len - cipher + 1
        
        nIndex = nIndex == 0 ? cipher : nIndex
        
        if(len <= cipher || cipher < 1){
            return v.replacingOccurrences(of: ",", with: "")
        }
        
        result = number.substring(from: 0, to: nIndex)
        while(nIndex <= nMax){
            result = result + "," + number.substring(from: nIndex, to: nIndex + 3 < len ? nIndex + 3 : len)
            nIndex = nIndex + cipher
        }
        
        if(v.replacingOccurrences(of: ",", with: "").components(separatedBy: ".").count > 1){
            result = result + "." + v.replacingOccurrences(of: ",", with: "").components(separatedBy: ".")[1]
        }
        
        return strSymbol + result
    }
}

extension String{
    func substring(from: Int, to:Int) -> String{
        guard from < count, to >= 0, to - from >= 0 else{
            return ""
        }
        
        var end = to + 1
        if(end >= self.count){end = end - 1}
        
        let startInfdex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: end)
        
        return String(self[startInfdex ..< endIndex])
    }
}
