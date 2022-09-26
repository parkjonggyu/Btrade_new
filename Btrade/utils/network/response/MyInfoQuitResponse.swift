//
//  MyInfoQuitResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/26.
//

import Foundation
struct MyInfoQuitResponse{
    let baseResponce: BaseResponse
    
    func getState() -> String?{
        if let modelAndView = baseResponce.data["modelAndView"] as? NSDictionary{
            if let state = modelAndView["status"] as? String{
                return state
            }
        }
        return nil
    }
    
    func getMsg() -> String?{
        let msg = baseResponce.data["msg"] as? String
        return msg
    }
}
