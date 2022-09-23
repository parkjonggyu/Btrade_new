//
//  InactiveChangePwRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/18.
//

import Foundation
import Alamofire

class InactiveChangePwRequest : BaseRequest{
    var passwd:String?
    var check_passwd:String?
    var mb_idx:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/changePwd.do")
    }
    
    override func setArg() {
        arg["passwd"] = passwd ?? ""
        arg["check_passwd"] = check_passwd ?? ""
        arg["mb_idx"] = mb_idx ?? ""
    }
}
