//
//  WithdrawOtpAuthResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/22.
//

import Foundation
struct WithdrawOtpAuthResponse{
    let baseResponce: BaseResponse
    
    func getResult() -> Bool{
        let index = "result"
        
        if let result = baseResponce.data[index] as? String{
            if(result == "SUCCESS"){
                return true
            }
            return false
        }
        return false
    }
}
