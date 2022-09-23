//
//  TermsInfoResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/12.
//

import Foundation

struct TermsInfoResponse{
    let baseResponce: BaseResponse

    func getFirstData() -> String?{
        if let array = baseResponce.data["array"] as? NSArray{
            for item in array{
                if let data = item as? NSDictionary{
                    return data["bc_contents"] as? String
                }
                return nil
            }
        }
        return nil
    }
}
