//
//  FindPWSendEmailResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/14.
//

import Foundation

struct FindPWSendEmailResponse{
    let baseResponce: BaseResponse

    func getCode() -> String?{
        let code = baseResponce.data["code"] as? String
        if let _ = code {
            return code
        }
        let c = baseResponce.data["code"] as? Int64
        return String(c!)
    }
}

