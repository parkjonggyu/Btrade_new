//
//  AccountConfirmResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/03.
//

import Foundation

struct AccountConfirmResponse{
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
    
    func getVerify_tr_dt() -> String?{
        let index = "verify_tr_dt"
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
    
    func getVerify_tr_no() -> String?{
        let index = "verify_tr_no"
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
    
    func getResult_Msg() -> String?{
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

