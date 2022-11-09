//
//  MemberInfoNoMaskRespose.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/26.
//

import Foundation

struct MemberInfoNoMaskRespose{
    let baseResponce: BaseResponse
    
    func getState() -> String?{
        if let modelAndView = baseResponce.data["data"] as? NSDictionary{
            if let state = modelAndView["state"]{
                return state as? String
            }
            if let c = modelAndView["state"] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getId() -> String?{
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let state = modelAndView["id"]{
                return state as? String
            }
        }
        return nil
    }
    
    func getNoMaskData() -> [String:Any]?{
        if let data = baseResponce.data["result"] as? [String:Any]{
            return data
        }
        return nil
    }
}
