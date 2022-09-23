//
//  MypageQNAAddResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/23.
//

import Foundation

struct MypageQNAAddResponse{
    let baseResponce: BaseResponse
    
    func getCode() -> String?{
        let index = "code"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
}
