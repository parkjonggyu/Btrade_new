//
//  SignupAuthRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/13.
//

import Foundation
import Alamofire

class SignupAuthRequest : BaseRequest{
    var email:String?
    var token:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonConfEmail.do")
    }
    
    override func setArg() {
        arg["email"] = email!
        arg["token"] = token!
    }
}
