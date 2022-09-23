//
//  MypageQNAHistoryResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/17.
//

import Foundation

struct MypageQNAHistoryResponse{
    let baseResponce: BaseResponse
    
    func getList() -> Array<Dictionary<String, Any>>?{
        let index = "list"
        if let code = baseResponce.data[index] as? Array<Dictionary<String, Any>>{
            return code
        }
        return nil
    }
    
    func getpageNo() -> Int{
        let index = "pageNo"
        if let modelAndView = baseResponce.data["paging"] as? NSDictionary{
            if let c = modelAndView[index] as? Int64{
                return Int(c)
            }
        }
        return 0
    }
    
    func getTotalCount() -> Int{
        let index = "totalCount"
        if let modelAndView = baseResponce.data["paging"] as? NSDictionary{
            if let c = modelAndView[index] as? Int64{
                return Int(c)
            }
        }
        return 0
    }
}
