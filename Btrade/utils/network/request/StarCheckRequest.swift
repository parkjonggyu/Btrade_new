//
//  StarCheckRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/07.
//

import Foundation
import Alamofire

class StarCheckRequest : BaseRequest{
    var coinType:String?
    var market_type:String?
    
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "common/updateMAttentionCoin.do")
    }
    
    override func setArg() {
        if let _ = coinType{arg["coinType"] = coinType!}
        if let _ = market_type{arg["market_type"] = market_type!}
    }
}
