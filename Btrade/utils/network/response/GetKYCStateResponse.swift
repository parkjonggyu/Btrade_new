//
//  GetKYCStateResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/18.
//

import Foundation

struct GetKYCStateResponse{
    let baseResponce: BaseResponse
    
    func getState() -> String?{
        let index = "state"
        if let modelAndView = baseResponce.data["data"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getAMLState() -> String?{
        let index = "aml_state"
        if let modelAndView = baseResponce.data["data"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getMsg() -> String?{
        let index = "msg"
        if let modelAndView = baseResponce.data["data"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getResult_cd() -> String{
        let index = "result_cd"
        if let modelAndView = baseResponce.data["data"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return "N"
    }
}
