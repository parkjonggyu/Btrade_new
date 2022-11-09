//
//  ServiceCoinResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/15.
//

import Foundation

struct ServiceCoinResponse{
    let baseResponce: BaseResponse
    
    func getList() -> Array<[String:Any]>?{
        let index = "list"
        if let code = baseResponce.data[index] as? Array<[String:Any]>{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            var list:Array<[String:Any]>?
            do{
                list = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? Array
                return list
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

