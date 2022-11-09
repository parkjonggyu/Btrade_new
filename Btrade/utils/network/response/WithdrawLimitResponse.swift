//
//  WithdrawLimitResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/20.
//

import Foundation
struct WithdrawLimitResponse{
    let baseResponce: BaseResponse
    
    func getOutMaxDay() -> Double{
        let index = "outMaxDay"
        
        if let result = baseResponce.data[index] as? Double{
            return result
        }
        if let result = baseResponce.data[index] as? Int64{
            return Double(result)
        }
        if let result = baseResponce.data[index] as? String{
            return Double(result) ?? 0
        }
        return 0
    }
    
    func getTodayTotalRequestAmount() -> Double{
        let index = "todayTotalRequestAmount"
        
        if let result = baseResponce.data[index] as? Double{
            return result
        }
        if let result = baseResponce.data[index] as? Int64{
            return Double(result)
        }
        if let result = baseResponce.data[index] as? String{
            return Double(result) ?? 0
        }
        return 0
    }
    
    func getOutMaxCount() -> Double{
        let index = "outMaxCount"
        
        if let result = baseResponce.data[index] as? Double{
            return result
        }
        if let result = baseResponce.data[index] as? Int64{
            return Double(result)
        }
        if let result = baseResponce.data[index] as? String{
            return Double(result) ?? 0
        }
        return 0
    }
    
    func getOutMinCount() -> Double{
        let index = "outMinCount"
        
        if let result = baseResponce.data[index] as? Double{
            return result
        }
        if let result = baseResponce.data[index] as? Int64{
            return Double(result)
        }
        if let result = baseResponce.data[index] as? String{
            return Double(result) ?? 0
        }
        return 0
    }
    
    func getNowPrice() -> Double{
        let index = "nowPrice"
        
        if let result = baseResponce.data[index] as? Double{
            return result
        }
        if let result = baseResponce.data[index] as? Int64{
            return Double(result)
        }
        if let result = baseResponce.data[index] as? String{
            return Double(result) ?? 0
        }
        return 0
    }
    
    
    func getVasps() -> Array<[String:Any]>?{
        let index = "vasps"
        if let code = baseResponce.data[index] as? Array<[String:Any]>{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            do{
                if let temp = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? [String:Any]{
                    if let list = temp["vasps"] as? Array<[String:Any]>{
                        return list
                    }
                }
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
