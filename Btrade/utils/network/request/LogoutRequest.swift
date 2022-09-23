//
//  LogoutRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/22.
//

import Foundation
import Alamofire

class LogoutRequest : BaseRequest{
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/api/account/logout.do")
    }
    
    override func setArg() {
        
    }
}
