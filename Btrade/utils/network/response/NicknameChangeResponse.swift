//
//  NicknameChangeResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/30.
//

import Foundation

struct NicknameChangeResponse{
    let baseResponce: BaseResponse
    
    func getState() -> String?{
        if let modelAndView = baseResponce.data["modelAndView"] as? NSDictionary{
            if let state = modelAndView["status"] as? String{
                return state
            }
        }
        return nil
    }
}
