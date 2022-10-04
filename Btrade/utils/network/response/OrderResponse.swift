//
//  OrderResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/04.
//

import Foundation

struct OrderResponse{
    let baseResponce: BaseResponse
    
    func getStatus() -> String?{
        let index = "status"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
    
    func getMessage() -> String?{
        let index = "message"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
}
