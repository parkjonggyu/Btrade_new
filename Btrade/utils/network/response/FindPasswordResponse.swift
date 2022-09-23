//
//  FindPasswordResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/14.
//

import Foundation

struct FindPasswordResponse{
    let baseResponce: BaseResponse

    func getCode() -> String?{
        let code = baseResponce.data["code"] as? String
        if let _ = code {
            return code
        }
        let c = baseResponce.data["code"] as? Int64
        return String(c!)
    }
    
    func getMsg() -> String?{
        let msg = baseResponce.data["msg"] as? String
        return String(msg!)
    }
    
    func getResult() -> String?{
        let msg = baseResponce.data["result"] as? String
        return String(msg!)
    }
    
    func getAmlState() -> String?{
        let msg = baseResponce.data["aml_state"] as? String
        return String(msg!)
    }
}
