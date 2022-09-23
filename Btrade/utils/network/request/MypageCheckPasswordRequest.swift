//
//  MypageCheckPasswordRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/21.
//

import Foundation
import Alamofire

class MypageCheckPasswordRequest : BaseRequest{
    var prev_passwd:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonPasswordCheck.do")
    }
    
    override func setArg() {
        if let _ = prev_passwd{arg["prev_passwd"] = prev_passwd!}
    }
}




