//
//  SignupRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/13.
//

import Foundation
import Alamofire

class SignupRequest : BaseRequest{
    var join_id:String?
    var join_password:String?
    var join_password_ok:String?
    var agree_yn:String?
    var agree_tos:String?
    var agree_privacy:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonSignup.do")
    }
    
    override func setArg() {
        arg["join_id"] = join_id!
        arg["join_password"] = join_password!
        arg["join_password_ok"] = join_password_ok!
        arg["agree_yn"] = agree_yn ?? "on"
        arg["agree_tos"] = agree_tos ?? "on"
        arg["agree_privacy"] = agree_privacy ?? "on"
    }
}
