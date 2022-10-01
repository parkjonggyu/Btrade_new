//
//  MainRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/30.
//

import Foundation
import Alamofire

class MainRequest : BaseRequest{
    var os:String = "ANDROID"
    
    init(){
        super.init(HttpMethod.get, BuildConfig.SERVER_URL, "m/main.do")
    }
    
    override func setArg() {
        arg["os"] = os
    }
}
