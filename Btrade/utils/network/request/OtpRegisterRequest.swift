//
//  OtpRegisterRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/25.
//

import Foundation
import Alamofire

class OtpRegisterRequest : BaseRequest{
    var otp:String?
    var mb_google_otp_key:String?
    var mb_recovery_code:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/mypage/updateOtp.do")
    }
    
    override func setArg() {
        if let _ = otp{arg["otp"] = otp!}
        if let _ = mb_google_otp_key{arg["mb_google_otp_key"] = mb_google_otp_key!}
        if let _ = mb_recovery_code{arg["mb_recovery_code"] = mb_recovery_code!}
    }
}
