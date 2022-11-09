//
//  SearchTradeListRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/11.
//

import Foundation

class SearchTradeListRequest : BaseRequest{
    var page_no:String?
    var startDate:String?
    var endDate:String?
    var market_code:String? = "BTC"
    var coin_code:String?
    var trd_type:String?
    
    
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "m/record/searchTrdList.do")
    }
    
    override func setArg() {
        if let _ = page_no{arg["page_no"] = page_no!}
        if let _ = startDate{arg["startDate"] = startDate!}
        if let _ = endDate{arg["endDate"] = endDate!}
        if let _ = market_code{arg["market_code"] = market_code!}
        if let _ = coin_code{arg["coin_code"] = coin_code!}
        if let _ = trd_type{arg["trd_type"] = trd_type!}
    }
}

