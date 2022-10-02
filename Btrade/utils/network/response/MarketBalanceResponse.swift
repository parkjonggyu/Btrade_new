//
//  MarketBalanceResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/02.
//

import Foundation

struct MarketBalanceResponse{
    let baseResponce: BaseResponse
    
    func getAccount() -> String?{
        if let account = baseResponce.data["account"] as? String{
            return account
        }
        return nil
    }
    
    func getMsg() -> String?{
        let msg = baseResponce.data["msg"] as? String
        return msg
    }
}
