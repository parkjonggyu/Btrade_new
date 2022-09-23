//
//  FindPasswordRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/14.
//

import Foundation
import Alamofire

class FindPasswordRequest : BaseRequest{
    var mb_id:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonFindPassWord.do")
    }
    
    override func setArg() {
        arg["mb_id"] = mb_id!
    }
}

