//
//  WithdrawInfoRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/19.
//

import Foundation

class WithdrawInfoRequest : BaseRequest{
    var os:String? = "ANDROID"
    var financeType:String? = "withdraw"
    var coinType:String?
    
    
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "m/finance/mobileExchange.do")
    }
    
    override func setArg() {
        if let _ = os{arg["os"] = os!}
        if let _ = financeType{arg["financeType"] = financeType!}
        if let _ = coinType{arg["coinType"] = coinType!}
    }
}
