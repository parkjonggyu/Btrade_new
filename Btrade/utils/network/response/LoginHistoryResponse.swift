//
//  LoginHistoryResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/24.
//

import Foundation

struct LoginHistoryResponse{
    let baseResponce: BaseResponse
    
    
    func getHistoryList() -> Array<Dictionary<String, Any>>?{
        let index = "historyList"
        if let code = baseResponce.data[index] as? Array<Dictionary<String, Any>>{
            return code
        }
        return nil
    }
    
}
