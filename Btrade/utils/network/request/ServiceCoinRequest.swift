//
//  ServiceCoinRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/15.
//

import Foundation
class ServiceCoinRequest : BaseRequest{
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "common/jsonFinanceServiceCoin.do")
    }
    
    override func setArg() {
    }
}
