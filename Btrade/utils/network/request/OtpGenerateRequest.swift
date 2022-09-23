//
//  OtpGenerateRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/24.
//

import Foundation
import Alamofire

class OtpGenerateRequest : BaseRequest{
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/mypage/otp.do")
    }
    
    override func setArg() {
    }
}
