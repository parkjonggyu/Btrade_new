//
//  WithdrawOtpAuthRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/22.
//

import Foundation

class WithdrawOtpAuthRequest : BaseRequest{
    var coinout_otp_number:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "finance/exchange/withdrawOtpAuthMobile.do")
    }
    
    override func setArg() {
        if let _ = coinout_otp_number{arg["coinout_otp_number"] = coinout_otp_number!}
    }
}
