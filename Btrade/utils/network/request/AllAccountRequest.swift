//
//  AllAccountRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/15.
//

import Foundation
class AllAccountRequest : BaseRequest{
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "asset/jsonGetAllDBAccount.do")
    }
    
    override func setArg() {
    }
}
