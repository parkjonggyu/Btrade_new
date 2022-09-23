//
//  MypageFAQAllRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/12.
//

import Foundation

struct MypageFAQAllResponse{
    let baseResponce: BaseResponse
    
    func getList() -> Array<Dictionary<String, Any>>?{
        let index = "list"
        if let code = baseResponce.data[index] as? Array<Dictionary<String, Any>>{
            return code
        }
        return nil
    }
    
}
