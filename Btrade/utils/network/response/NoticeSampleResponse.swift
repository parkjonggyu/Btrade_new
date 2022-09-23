//
//  NoticeSampleResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/08.
//

import Foundation

struct NoticeSampleResponse{
    let baseResponce: BaseResponse
    
    func getSample() -> Array<Dictionary<String, Any>>?{
        let index = "sample"
        if let code = baseResponce.data[index] as? Array<Dictionary<String, Any>>{
            return code
        }
        return nil
    }
}



