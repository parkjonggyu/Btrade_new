//
//  NoticeSampleRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/08.
//

import Foundation
import Alamofire

class NoticeSampleRequest : BaseRequest{
    var auth_code:String?
    
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "m/mypage/noticeSample.do")
    }
    
    override func setArg() {
        
    }
}

