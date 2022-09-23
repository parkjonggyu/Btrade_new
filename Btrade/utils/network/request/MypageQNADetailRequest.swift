//
//  MypageQNADetailRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/23.
//

import Foundation
import Alamofire

class MypageQNADetailRequest : BaseRequest{
    var bq_idx:String?
    var os:String = "ANDROID"
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "board/qnaboard_detail.do")
    }
    
    override func setArg() {
        arg["bq_idx"] = bq_idx ?? ""
        arg["os"] = os
    }
}
