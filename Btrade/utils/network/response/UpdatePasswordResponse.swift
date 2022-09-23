//
//  UpdatePasswordResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/23.
//

import Foundation
struct UpdatePasswordResponse{
    let baseResponce: BaseResponse
    
    func getMsg() -> String?{
        let index = "msg"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
}
