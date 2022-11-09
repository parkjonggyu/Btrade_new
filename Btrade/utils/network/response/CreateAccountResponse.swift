//
//  CreateAccountResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/19.
//

import Foundation

struct CreateAccountResponse{
    let baseResponce: BaseResponse
    
    func getCode() -> String?{
        let index = "code"
        if let ms_nm = baseResponce.data[index] as? String{
            return ms_nm
        }
        return nil
    }
    
    func getMap() -> String?{
        let index = "map"
        if let result = baseResponce.data[index] as? String{
            if(result == "0"){return nil}
            return result
        }
        
        if let result = baseResponce.data[index] as? Int64{
            if(result == 0){return nil}
            return String(result)
        }
        return nil
    }
    
    func getAccount() -> [String:Any]?{
        let index = "account"
        if let result = baseResponce.data[index] as? [String:Any]{
           return result
        }
        return nil
    }
}
