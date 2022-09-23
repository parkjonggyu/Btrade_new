//
//  GetKYCStateRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/18.
//

import Foundation
import Alamofire

class GetKYCStateRequest : BaseRequest{
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/getAMLState.do")
    }
    
    override func setArg() {
    }
}
