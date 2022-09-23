//
//  InactiveEmailConfirmRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/18.
//

import Foundation
import Alamofire

class InactiveEmailConfirmRequest : BaseRequest{
    var mb_id:String?
    var token:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/confirmEmailAuthCode.do")
    }
    
    override func setArg() {
        arg["mb_id"] = mb_id ?? ""
        arg["token"] = token ?? ""
    }
}

