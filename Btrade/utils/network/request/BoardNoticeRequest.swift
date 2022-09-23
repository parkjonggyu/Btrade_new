//
//  BoardNoticeRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/11.
//

import Foundation
import Alamofire

class BoardNoticeRequest : BaseRequest{
    let os:String = "ANDROID"
    var searchValue:String?
    
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "m/mypage/notice.do")
    }
    
    override func setArg() {
        arg["os"] = os
        arg["searchValue"] = searchValue ?? ""
    }
}
