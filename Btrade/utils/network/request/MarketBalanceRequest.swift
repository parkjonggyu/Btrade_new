//
//  MarketBalanceRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/02.
//

import Foundation
import Alamofire

class MarketBalanceRequest : BaseRequest{
    var coinType:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "asset/jsonGetDBAccount.do")
    }
    
    override func setArg() {
        if let _ = coinType{arg["coinType"] = coinType!}
    }
}
