//
//  NicknameChangeRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/30.
//

import Foundation

class NicknameChangeRequest : BaseRequest{
    var nickname:String?
   
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/mypage/updateNickname.do")
    }
    
    override func setArg() {
        if let _ = nickname{arg["nickname"] = nickname!}
    }
}
