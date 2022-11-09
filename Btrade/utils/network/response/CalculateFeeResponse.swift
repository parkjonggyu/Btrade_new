//
//  CalculateFeeResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/18.
//

import Foundation

struct CalculateFeeResponse{
    let baseResponce: BaseResponse
    
    func getFee() -> String?{
        let index = "MS_NM"
        if let fee = baseResponce.data["feeMap"] as? [String:Any]{
            if let ms_nm = fee[index] as? String{
                return ms_nm
            }
            
            if let ms_nm = fee[index] as? Double{
                return String(ms_nm)
            }
        }
        return nil
    }
    
}

