//
//  WithdrawLimitRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/20.
//

import Foundation

class WithdrawLimitRequest : BaseRequest{
    var coin_type:String?
    var coinType:String?
    
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "finance/selectOutRequest.do")
    }
    
    override func setArg() {
        if let _ = coin_type{arg["coin_type"] = coin_type!}
        if let _ = coinType{arg["coinType"] = coinType!}
    }
}
