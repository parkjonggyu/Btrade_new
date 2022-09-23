//
//  Kyc3UploadResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/02.
//

import Foundation

struct Kyc3UploadResponse{
    let baseResponce: BaseResponse
    
    func getResult_cd() -> String?{
        let index = "result_cd"
        if let modelAndView = baseResponce.data as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getResult_msg() -> String?{
        let index = "result_msg"
        if let modelAndView = baseResponce.data as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
}
