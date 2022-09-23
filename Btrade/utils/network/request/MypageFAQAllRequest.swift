//
//  MypageFAQAllRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/12.
//

import Foundation
import Alamofire

class MypageFAQAllRequest : BaseRequest{
    let os:String = "ANDROID"
    var searchValue:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "board/qnaboard_list.do")
    }
    
    override func setArg() {
        arg["os"] = os
        arg["searchValue"] = searchValue ?? ""
    }
}
