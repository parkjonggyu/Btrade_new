//
//  MainResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/30.
//

import Foundation
struct MainResponse{
    let baseResponce: BaseResponse
    
    func getJsonList() -> String?{
        if let json_list = baseResponce.data["json_list"] as? String{
            return json_list
        }
        return nil
    }
    
    func getMsg() -> String?{
        let msg = baseResponce.data["msg"] as? String
        return msg
    }
}

struct MyCoinData : Codable{
    var attention_coin:String
    var attention_coin_BTC:String
    var avg_coin_price:Double
    var balance:Double
    var coin_code:String
    var coin_kr:String
    var coin_name:String
    var en_coin_name:String
    var expected_listing:String
    var market_btc_status:String
    var market_eth_status:String
    var market_hup_status:String
    var market_krw_status:String
    var market_usd_status:String
    var market_usdt_status:String
    var market_uzs_status:String
    var sort:Int
    var kwr_btc:Double
    var now_price:Double
    var prev_price:Double
    var all_vol:Double
}
