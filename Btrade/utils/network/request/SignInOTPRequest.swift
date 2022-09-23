//
//  SignInOTPRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/11.
//

import Foundation
import Alamofire

class SignInOTPRequest : BaseRequest{
    var login_id:String?
    var login_password:String?
    var otp_check:String?
    var otp_number:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonSignin.do")
    }
    
    override func setArg() {
        arg["auto_login"] = "Y"
        arg["login_id"] = login_id ?? ""
        arg["login_password"] = login_password ?? ""
        arg["otp_check"] = "N"
        arg["otp_number"] = otp_number ?? ""
    }
}

