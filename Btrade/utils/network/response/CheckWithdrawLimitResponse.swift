//
//  CheckWithdrawLimitResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/22.
//

import Foundation

struct CheckWithdrawLimitResponse{
    let baseResponce: BaseResponse
    
    func getResult() -> String?{
        let index = "result"
        if let fee = baseResponce.data["result"] as? [String:Any]{
            if let ms_nm = fee[index] as? String{
                return ms_nm
            }
        }
        return nil
    }
}
