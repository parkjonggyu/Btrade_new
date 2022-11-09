//
//  WithdepHistoryResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/24.
//

import Foundation

struct WithdepHistoryResponse{
    let baseResponce: BaseResponse
    
    func getListExc() -> NSArray?{
        let index = "listExc"
        if let code = baseResponce.data[index] as? NSArray{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            var list:NSArray?
            do{
                list = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? NSArray
                return list
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    func getTotalCount() -> Int{
        let index = "totalCount"
        if let data = baseResponce.data["Paging"] as? NSDictionary{
            if let c = data[index] as? Int64{
                return Int(c)
            }
        }
        
        return 0
    }
    
    func getPageNo() -> Int{
        let index = "pageNo"
        if let data = baseResponce.data["Paging"] as? NSDictionary{
            if let c = data[index] as? Int64{
                return Int(c)
            }
        }
        
        return 0
    }
}

