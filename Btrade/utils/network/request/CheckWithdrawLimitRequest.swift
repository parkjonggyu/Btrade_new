//
//  CheckWithdrawLimitRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/22.
//

import Foundation

class CheckWithdrawLimitRequest : BaseRequest{
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "finance/checkWithdrawLimit.do")
    }
    
    override func setArg() {
    }
}
