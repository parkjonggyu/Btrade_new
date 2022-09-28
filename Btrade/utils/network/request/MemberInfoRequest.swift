//
//  MemberInfoRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/08.
//

import Foundation
import Alamofire

class MemberInfoRequest : BaseRequest{
    var os:String? = "ANDROID"
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/mypage/jsonMyInfo.do")
    }
    
    override func setArg() {
        arg["os"] = os ?? ""
    }
}

