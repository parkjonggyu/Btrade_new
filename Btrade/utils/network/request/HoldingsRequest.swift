//
//  HoldingsRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/09.
//

import Foundation

class HoldingsRequest : BaseRequest{
    var os:String? = "ANDROID"
    
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/asset/asset.do")
    }
    
    override func setArg() {
        if let _ = os{arg["os"] = os!}
    }
}
