//
//  MyInfoLeaveAssetRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/23.
//

import Foundation
import Alamofire

class MyInfoLeaveAssetRequest : BaseRequest{
    var prev_passwd:String?
    var passwd:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/mypage/updatePassword.do")
    }
    
    override func setArg() {
        if let _ = prev_passwd{arg["prev_passwd"] = prev_passwd!}
        if let _ = passwd{arg["passwd"] = passwd!}
    }
}
