//
//  CreateAccountRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/19.
//

import Foundation

class CreateAccountRequest : BaseRequest{
    var coinType:String?
    
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "finance/jsonCreateAccount.do")
    }
    
    override func setArg() {
        if let _ = coinType{arg["coinType"] = coinType!}
    }
}
