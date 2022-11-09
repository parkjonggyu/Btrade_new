//
//  MypageEventRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/30.
//

import Foundation

class MypageEventRequest : BaseRequest{
    var query:String?
   
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/mypage/events.do")
    }
    
    override func setArg() {
        if let _ = query{arg["query"] = query!}
    }
}
