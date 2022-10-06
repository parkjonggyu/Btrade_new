//
//  TradeHistoryResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/06.
//

import Foundation

struct TradeHistoryResponse{
    let baseResponce: BaseResponse
    
    func getList() -> Array<Dictionary<String, Any>>?{
        let index = "dataList"
        if let data = baseResponce.data["data"] as? NSDictionary{
            if let code = data[index] as? Array<Dictionary<String, Any>>{
                return code
            }
        }
        return nil
    }
    
    
    func getpageNo() -> Int{
        let index = "pageNum"
        if let data = baseResponce.data["data"] as? NSDictionary{
            if let c = data[index] as? Int64{
                return Int(c)
            }
        }
        
        return 0
    }
    
    func getTotalCount() -> Int{
        let index = "totalCount"
        if let data = baseResponce.data["data"] as? NSDictionary{
            if let c = data[index] as? Int64{
                return Int(c)
            }
        }
        
        return 0
    }
    
    func getFinalPageNum() -> Int{
        let index = "finalPageNum"
        if let data = baseResponce.data["data"] as? NSDictionary{
            if let c = data[index] as? Int64{
                return Int(c)
            }
        }
        
        return 0
    }
}
