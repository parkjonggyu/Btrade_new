//
//  LoginHistoryRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/24.
//

import Foundation
import Alamofire

class LoginHistoryRequest : BaseRequest{
    var os:String = "ANDROID"
    
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "m/mypage/certify/certify.do")
    }
    
    override func setArg() {
        arg["os"] = os
    }
}
