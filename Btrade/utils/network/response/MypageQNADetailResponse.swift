//
//  MypageQNADetailResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/23.
//

import Foundation

struct MypageQNADetailResponse{
    let baseResponce: BaseResponse
    
    func getList() -> Array<[String: Any]>?{
        let index = "conversationList"
        if let code = baseResponce.data[index] as? Array<[String: Any]>{
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
    
    func getFirstQuestion() -> [String: Any]?{
        let index = "firstQuestion"
        if let code = baseResponce.data[index] as? [String: Any]{
            return code
        }
        return nil
    }
    
    func getConversation() -> [String: Any]?{
        let index = "conversation"
        if let code = baseResponce.data[index] as? [String: Any]{
            return code
        }
        return nil
    }
    
    
}
