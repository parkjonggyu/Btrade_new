//
//  InactiveEmailRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/18.
//

import Foundation
import Alamofire

class InactiveEmailRequest : BaseRequest{
    var email:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonAccountSendEmail.do")
    }
    
    override func setArg() {
        arg["email"] = email ?? ""
    }
}
