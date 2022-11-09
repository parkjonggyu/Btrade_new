//
//  CoinUtils.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/08.
//

import Foundation


class CoinUtils{
    
    static func getlevel(_ memberInfo:MemberInfo) -> Int{
        
        if(memberInfo.mb_idx == "83216"){return 3}
        
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
    
    static func hogaPolicy(_ MARKETTYPE:String?,_ price:Double) ->Double{
        if let market = MARKETTYPE {
            if(market == "BTC"){return 0.00000001}
        }
        return 0.0
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
            number = number.replacingOccurrences(of: "-", with: "")
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
            result = result + "," + number.substring(from: nIndex, to: nIndex + 3)
            nIndex = nIndex + cipher
        }
        
        if(v.replacingOccurrences(of: ",", with: "").components(separatedBy: ".").count > 1){
            result = result + "." + v.replacingOccurrences(of: ",", with: "").components(separatedBy: ".")[1]
        }
        
        return strSymbol + result
    }
    
    static func toFixed(_ value:Double,_ scale:Int) -> String{
        if(scale == 1){return String(format: "%.1f", value)}
        else if(scale == 2){return String(format: "%.2f", value)}
        else if(scale == 3){return String(format: "%.3f", value)}
        else if(scale == 4){return String(format: "%.4f", value)}
        else if(scale == 5){return String(format: "%.5f", value)}
        else if(scale == 6){return String(format: "%.6f", value)}
        else if(scale == 7){return String(format: "%.7f", value)}
        return String(format: "%.8f", value)
      }
    
    static func fCalcProfitDif(_ balance:Decimal, _ totalBuy:Decimal, feeString:String?) -> [String:Any]{
        var fee:Decimal?
        var dif:Decimal?
        var reverse_fee:Decimal?
        var dif_per:Decimal?
        
        if let f = feeString{
            fee = DoubleDecimalUtils.newInstance(f)
            reverse_fee = Decimal(1) - fee!
            dif = balance - totalBuy
            dif = dif! * reverse_fee!
        }else{
            dif = balance - totalBuy
        }
        
        dif_per = totalBuy == Decimal.zero ? Decimal.zero : (dif! / totalBuy)
        dif_per = dif_per! * Decimal(100)
        
        var rtn_dif_per_str:String?
        var rtn_dif_per_num:Double?
        var rtn_dif_str:String?
        var rtn_dif_num:Double?
        
        if(dif_per! > Decimal.zero){
            rtn_dif_per_str = "+" + fCommaNum(dif_per!, Decimal(0))
            rtn_dif_per_num = NSDecimalNumber(decimal: dif_per!).doubleValue
            rtn_dif_str = "+" + fCommaNum(dif!, Decimal(0))
            rtn_dif_num = NSDecimalNumber(decimal: dif!).doubleValue
        }else if(dif_per! < Decimal.zero){
            rtn_dif_per_str = fCommaNum(dif_per!, Decimal(0))
            rtn_dif_per_num = NSDecimalNumber(decimal: dif_per!).doubleValue
            rtn_dif_str = fCommaNum(dif!, Decimal(0))
            rtn_dif_num = NSDecimalNumber(decimal: dif!).doubleValue
        }else{
            rtn_dif_per_str = "0"
            rtn_dif_per_num = 0
            rtn_dif_str = "0"
            rtn_dif_num = 0
        }
        
        var data:[String:Any] = [String:Any]()
        data["dif_per_str"] = rtn_dif_per_str
        data["dif_per_num"] = rtn_dif_per_num!
        data["dif_str"] = rtn_dif_str
        data["dif_num"] = rtn_dif_num!
        
        return data
    }
    
    static func fCommaNum(_ val:Decimal,_ num:Decimal) -> String{
        if(val == Decimal.zero){return NSDecimalNumber(decimal: val).stringValue}
        
        var valDouble:Double = NSDecimalNumber(decimal: val).doubleValue
        if(num == Decimal.zero){
            valDouble = floor(NSDecimalNumber(decimal: val).doubleValue)
        }else if(num > Decimal.zero){
            let temp = (val * num) / num
            valDouble = floor(NSDecimalNumber(decimal: temp).doubleValue)
        }
        
        //let reg = "/(^[+-]?\\d+)(\\d{3})/;"
        //let n = String(valDouble)
        
        return String(valDouble)
    }
}

extension String{
    func substring(from: Int, to:Int) -> String{
        guard from < count, to >= 0, to - from >= 0 else{
            return ""
        }
        
        var end = to
        if(end > self.count){end = self.count}
        
        let startInfdex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: end)
        
        return String(self[startInfdex ..< endIndex])
    }
}
