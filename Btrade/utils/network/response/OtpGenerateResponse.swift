//
//  OtpGenerateResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/24.
//

import Foundation

struct OtpGenerateResponse{
    let baseResponce: BaseResponse
    
    
    func getResult() -> NSDictionary?{
        let index = "result"
        if let code = baseResponce.data[index]  as? NSDictionary{
            return code
        }
        return nil
    }
    
}
