//
//  BoardNoticeResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/11.
//

import Foundation

struct BoardNoticeResponse{
    let baseResponce: BaseResponse
    
    func getImportantList() -> Array<Dictionary<String, Any>>?{
        let index = "importantList"
        if let code = baseResponce.data[index] as? Array<Dictionary<String, Any>>{
            return code
        }
        return nil
    }
    
    func getList() -> Array<Dictionary<String, Any>>?{
        let index = "list"
        if let code = baseResponce.data[index] as? Array<Dictionary<String, Any>>{
            return code
        }
        return nil
    }
    
    func getListCount() -> String?{
        let index = "listCount"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
}
