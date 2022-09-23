//
//  MemberInfoRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/08.
//

import Foundation
import Alamofire

class MemberInfoRequest : BaseRequest{
    var auth_code:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonMyInfo.do")
    }
    
    override func setArg() {
        
    }
}

