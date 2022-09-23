//
//  InactivePhoneResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/15.
//

import Foundation

struct InactivePhoneResponse{
    let baseResponce: BaseResponse

    func getCode() -> String?{
        let index = "code"
        guard let _ = baseResponce.data[index] else {return nil}
        
        let code = baseResponce.data[index] as? String
        if let _ = code {
            return code
        }
        let c = baseResponce.data[index] as? Int64
        return String(c!)
    }
    
    func getResult() -> String?{
        let index = "result"
        guard let _ = baseResponce.data[index] else {return nil}
        
        let code = baseResponce.data[index] as? String
        if let _ = code {
            return code
        }
        let c = baseResponce.data[index] as? Int64
        return String(c!)
    }
    
    
}


