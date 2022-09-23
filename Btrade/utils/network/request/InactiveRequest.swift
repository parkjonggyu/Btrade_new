//
//  InactiveRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/15.
//

import Foundation
import Alamofire

class InactiveRequest : BaseRequest{
    var mb_id:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/findActivation.do")
    }
    
    override func setArg() {
        arg["mb_id"] = mb_id ?? ""
    }
}

