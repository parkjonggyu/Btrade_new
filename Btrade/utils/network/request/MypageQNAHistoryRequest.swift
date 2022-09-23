//
//  MypageQNAHistoryRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/17.
//

import Foundation
import Alamofire

class MypageQNAHistoryRequest : BaseRequest{
    let os = "ANDROID"
    var page_no:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "board/qnaboard_reg_list.do")
    }
    
    override func setArg() {
        arg["os"] = os
        arg["page_no"] = page_no ?? "0"
    }
}

