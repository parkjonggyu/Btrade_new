//
//  VersionCheckRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/01.
//

import Foundation
import Alamofire

class VersionCheckRequest : BaseRequest{
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "m/api/v2/versionCheck.do")
    }
    
    override func setArg() {
        arg["os"] = "iPhone"
    }
}
