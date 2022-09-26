//
//  MemberInfoNoMaskRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/26.
//

import Foundation
import Alamofire

class MemberInfoNoMaskRequest : BaseRequest{
    var os:String? = "ANDROID"
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "mypage/myInfoNoMask.do")
    }
    
    override func setArg() {
        arg["os"] = os ?? ""
    }
}
