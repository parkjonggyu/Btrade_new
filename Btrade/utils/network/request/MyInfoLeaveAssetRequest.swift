//
//  MyInfoLeaveAssetRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/23.
//

import Foundation
import Alamofire

class MyInfoLeaveAssetRequest : BaseRequest{
    var os:String? = "ANDROID"
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/mypage/quitAccountInfoAsset.do")
    }
    
    override func setArg() {
        if let _ = os{arg["os"] = os!}
    }
}
