//
//  TradeHistoryRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/06.
//

import Foundation
import Alamofire

class TradeHistoryRequest : BaseRequest{
    var page_num:Int?
    var market_code:String?
    var coin_code:String?
    var sortType:String?
    var serviceType:String?
    var sortColumnName:String?
    
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "trade/searchTradeListMarketPre.do")
    }
    
    override func setArg() {
        if let _ = page_num{arg["page_num"] = page_num!}
        if let _ = market_code{arg["market_code"] = market_code!}
        if let _ = coin_code{arg["coin_code"] = coin_code!}
        if let _ = sortType{arg["sortType"] = sortType!}
        if let _ = serviceType{arg["serviceType"] = serviceType!}
        if let _ = sortColumnName{arg["sortColumnName"] = sortColumnName!}
    }
}
