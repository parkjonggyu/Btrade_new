//
//  AllAccountResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/15.
//

import Foundation

struct AllAccountResponse{
    let baseResponce: BaseResponse
    
    func getAccount() -> [String:Any]?{
        let index = "account"
        if let code = baseResponce.data[index] as? [String:Any]{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            var list:[String:Any]?
            do{
                list = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? [String:Any]
                return list
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
