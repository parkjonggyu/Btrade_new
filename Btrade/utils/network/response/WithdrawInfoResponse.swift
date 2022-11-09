//
//  WithdrawInfoResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/19.
//

import Foundation

struct WithdrawInfoResponse{
    let baseResponce: BaseResponse
    
    func getLimitAmountCount() -> Double{
        let index = "limitAmountCount"
        
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
    
    func getMinLimit() -> Double{
        let index = "minLimit"
        
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
    
    func getTodayRemainLimit() -> Double{
        let index = "today_remain_limit"
        
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
    
    func getMbLang() -> String?{
        let index = "mbLang"
        if let ms_nm = baseResponce.data[index] as? String{
            return ms_nm
        }
        return nil
    }
    
    func getBtreeMemberYn() -> String?{
        let index = "btreeMemberYn"
        if let result = baseResponce.data[index] as? String{
            if(result == "0"){return nil}
            return result
        }
        return nil
    }
    
    func getShuffleHpxAddress() -> String?{
        let index = "shuffleHpxAddress"
        if let result = baseResponce.data[index] as? String{
            if(result == "0"){return nil}
            return result
        }
        return nil
    }
    
    func getRealExchangeCan() -> Double{
        let index = "realExchangeCan"
        
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
}
