//
//  HoldingsResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/09.
//

import Foundation

struct HoldingsResponse{
    let baseResponce: BaseResponse
    
    func getJson_coin_balance() -> String?{
        let index = "json_coin_balance"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
    
    
    func getCoinList() -> String?{
        let index = "service_coin_list"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
    
    func getMarketist() -> String?{
        let index = "marketList"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
}
