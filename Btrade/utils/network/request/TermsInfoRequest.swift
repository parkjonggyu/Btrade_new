//
//  TermsInfoRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/12.
//

import Foundation
import Alamofire

class TermsInfoRequest : BaseRequest{
    var bc_channel:String?
    
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "m/main/termsInfo.do")
    }
    
    override func setArg() {
        arg["bc_channel"] = bc_channel ?? "1"
    }
}
