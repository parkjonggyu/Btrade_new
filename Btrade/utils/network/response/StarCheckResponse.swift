//
//  StarCheckResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/07.
//

import Foundation

struct StarCheckResponse{
    let baseResponce: BaseResponse
    
    func getAttentionCoin() -> Bool{
        let index = "attentionCoin"
        if let data = baseResponce.data[index] as? Bool{
            return data
        }
        return false
    }
    
}

