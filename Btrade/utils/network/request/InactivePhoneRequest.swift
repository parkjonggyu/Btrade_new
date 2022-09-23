//
//  InactivePhoneRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/15.
//

import Foundation
import Alamofire

class InactivePhoneRequest : BaseRequest{
    var mb_idx:String?
    var find_type:String?
    var email_type:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonAuthSendSMS.do")
    }
    
    override func setArg() {
        arg["mb_idx"] = mb_idx ?? ""
        arg["find_type"] = find_type ?? "2"
        arg["email_type"] = email_type ?? "password"
    }
}

