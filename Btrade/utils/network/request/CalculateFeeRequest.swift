//
//  CalculateFeeRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/18.
//

import Foundation

class CalculateFeeRequest : BaseRequest{
    var coinType:String?
    var marketType:String? = "BTC"
    
    
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "code/JsonCoinOutFee.do")
    }
    
    override func setArg() {
        if let _ = coinType{arg["coinType"] = coinType!}
        if let _ = marketType{arg["marketType"] = marketType!}
    }
}
