//
//  MypageEventResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/30.
//

import Foundation

struct MypageEventResponse{
    let baseResponce: BaseResponse
    
    func getEvents() -> NSArray?{
        let index = "events"
        if let code = baseResponce.data[index] as? NSArray{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            var list:NSArray?
            do{
                list = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? NSArray
                return list
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
