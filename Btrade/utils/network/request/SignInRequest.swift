//
//  SignInRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/07.
//

import Foundation
import Alamofire

class SignInRequest : BaseRequest{
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
        //arg["otp_check"] = otp_check ?? ""
        //arg["otp_number"] = otp_number ?? ""
    }
}
