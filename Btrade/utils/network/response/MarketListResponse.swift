//
//  MarketListResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/04.
//

import Foundation

struct MarketListResponse{
    let baseResponce: BaseResponse
    
    
    func getData() -> Array<Coin>{
        var result = Array<Coin>()
        if let data = baseResponce.data["data"] as? Array<[String:Any]>{
            for dic in data{
                let newCoin = Coin(coin_code: dic["coin_code"] as? String ?? "", en_coin_name: dic["en_coin_name"]  as? String ?? "", coin_name: dic["coin_name"]  as? String ?? "", sort: dic["sort"]  as? String ?? "", coin_kr: dic["coin_kr"]  as? String ?? "")
                result.append(newCoin)
            }
        }
        return result;
    }
    
    struct Coin{
        var coin_code:String
        var en_coin_name:String
        var coin_name:String
        var sort:String
        var coin_kr:String
    }
}
