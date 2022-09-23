//
//  MypageQNADetailResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/23.
//

import Foundation

struct MypageQNADetailResponse{
    let baseResponce: BaseResponse
    
    func getList() -> Array<Dictionary<String, Any>>?{
        let index = "replyList"
        if let code = baseResponce.data[index] as? Array<Dictionary<String, Any>>{
            return code
        }
        return nil
    }
    
    func getDetail() -> Dictionary<String, Any>?{
        let index = "detail"
        if let code = baseResponce.data[index] as? Dictionary<String, Any>{
            return code
        }
        return nil
    }
}
