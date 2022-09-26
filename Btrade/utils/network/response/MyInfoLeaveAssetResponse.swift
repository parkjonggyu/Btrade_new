//
//  MyInfoLeaveAssetResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/23.
//

import Foundation
struct MyInfoLeaveAssetResponse{
    let baseResponce: BaseResponse
    
    func getIsAllowed() -> String?{
        let index = "isAllowed"
        
        print(type(of: baseResponce.data[index]!))
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Bool{
            return String(c)
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
    
    func getTotal_assets() -> String?{
        let index = "total_assets"
        if let code = baseResponce.data[index] as? String{
            return code
        }
        if let c = baseResponce.data[index] as? Int64{
            return String(c)
        }
        return nil
    }
}
