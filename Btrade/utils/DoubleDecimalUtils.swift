//
//  DoubleDecimalUtils.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/27.
//

import Foundation

class DoubleDecimalUtils{
    
    static func newInstance(_ d:String?) -> Decimal{
        if var double = d{
            do {
                double = try double.replacingOccurrences(of: ",", with: "")
                let result = Decimal(string:double) ?? Decimal(0)
                return result
            } catch {
                print("DoubleDecimalUtils - Error")
            }
            
        }
        return Decimal(0)
    }
    
    static func newInstance(_ d:Double?) -> Decimal{
        if let double = d{
            return Decimal(double)
        }
        return Decimal(0)
    }
    
    static func add(_ a:Decimal, _ b:Decimal) -> Double{
        return ((a + b) as NSDecimalNumber).doubleValue
    }
    
    static func subtract(_ a:Decimal, _ b:Decimal) -> Double{
        if((a as NSDecimalNumber).doubleValue == 0){return 0}
        return ((a - b) as NSDecimalNumber).doubleValue
    }
    
    static func div(_ a:Decimal, _ b:Decimal) -> Double{
        if((a as NSDecimalNumber).doubleValue == 0 || (b as NSDecimalNumber).doubleValue == 0){return 0}
        return ((a / b) as NSDecimalNumber).doubleValue * 100
    }
    
    static func mul(_ a:Decimal, _ b:Decimal) -> Double{
        if((a as NSDecimalNumber).doubleValue == 0 || (b as NSDecimalNumber).doubleValue == 0){return 0}
        return ((a * b) as NSDecimalNumber).doubleValue
    }
    
    static func mul(_ sss:String, _ b:Decimal) -> Double{
        let a = newInstance(sss)
        if((a as NSDecimalNumber).doubleValue == 0 || (b as NSDecimalNumber).doubleValue == 0){return 0}
        return ((a * b) as NSDecimalNumber).doubleValue
    }
    
    static func doubleValue(_ a:Decimal) -> Double?{
        return (a as NSDecimalNumber).doubleValue
    }
    
    static func doubleValue(_ a:Decimal?) -> Double?{
        return NSDecimalNumber(decimal: a ?? newInstance("")).doubleValue
    }
    
    static func withoutExp(_ d:Double) -> String{
        return setMaximumFractionDigits(d,scale: 8)
    }
    
    static func withoutExp(_ d:Int) -> String{
        return setMaximumFractionDigits(Double(d) ,scale: 8)
    }
    
    static func withoutExp(_ a:Decimal) -> String{
        return setMaximumFractionDigits((a as NSDecimalNumber).doubleValue ,scale: 8)
    }
    
    static func setMaximumFractionDigits(decimal:Decimal, scale:Int) -> String{
        return setMaximumFractionDigits((decimal as NSDecimalNumber).doubleValue, scale:scale)
    }
    
    static func setMaximumFractionDigits(_ d:Double, scale:Int) -> String{
        var formattedValue = "%.8f"
        switch(scale){
        case 0:
            formattedValue = "%.0f"
        case 1:
            formattedValue = "%.1f"
        case 2:
            formattedValue = "%.2f"
        case 3:
            formattedValue = "%.3f"
        case 4:
            formattedValue = "%.4f"
        case 5:
            formattedValue = "%.5f"
        case 6:
            formattedValue = "%.6f"
        case 7:
            formattedValue = "%.7f"
        case 8:
            formattedValue = "%.8f"
        default:
            formattedValue = "%.8f"
        }
        return String(format: formattedValue, d)
    }
    
    static func removeLastZero(_ s:Decimal) -> String{
        return NSDecimalNumber(decimal: s).stringValue
    }
    
    static func removeLastZero(_ s:Double) -> String{
        return NSDecimalNumber(decimal: newInstance(s)).stringValue
    }
    
    static func removeLastZero(_ s:String) -> String{
        return NSDecimalNumber(decimal: newInstance(s)).stringValue
    }
}

