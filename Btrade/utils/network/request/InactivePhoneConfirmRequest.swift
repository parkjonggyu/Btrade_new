//
//  InactivePhoneConfirmRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/15.
//

import Foundation
import Alamofire

class InactivePhoneConfirmRequest : BaseRequest{
    var mb_idx:String?
    var code:String?
    var find_type:String?
    var idx:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonAuthSendSMSConfirm.do")
    }
    
    override func setArg() {
        arg["mb_idx"] = mb_idx ?? ""
        arg["code"] = code ?? "2"
        arg["find_type"] = find_type ?? "2"
        arg["idx"] = idx ?? "password"
    }
}
