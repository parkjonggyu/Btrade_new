//
//  OrderRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/04.
//

import Foundation
import Alamofire

class OrderRequest : BaseRequest{
    var coin_code:String?
    var market_code:String?
    var trd_type:String?
    var tradePw:String?
    var trade_pw_check:String?
    var amtBuy:String?
    var priceBuy:String?
    var amtSell:String?
    var priceSell:String?
    var krw_price:String?
    var amtCancel:String?
    var org_ord_no:String?
    
    
    var deleteIdx:Int?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "trade/orderMarketPre.do")
    }
    
    override func setArg() {
        if let _ = coin_code{arg["coin_code"] = coin_code!}
        if let _ = market_code{arg["market_code"] = market_code!}
        if let _ = trd_type{arg["trd_type"] = trd_type!}
        if let _ = tradePw{arg["tradePw"] = tradePw!}
        if let _ = trade_pw_check{arg["trade_pw_check"] = trade_pw_check!}
        if let _ = amtBuy{arg["amtBuy"] = amtBuy!}
        if let _ = priceBuy{arg["priceBuy"] = priceBuy!}
        if let _ = amtSell{arg["amtSell"] = amtSell!}
        if let _ = priceSell{arg["priceSell"] = priceSell!}
        if let _ = krw_price{arg["krw_price"] = krw_price!}
        if let _ = amtCancel{arg["amtCancel"] = amtCancel!}
        if let _ = org_ord_no{arg["org_ord_no"] = org_ord_no!}
    }
}

