//
//  FindPWSendEmailRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/14.
//

import Foundation
import Alamofire

class FindPWSendEmailRequest : BaseRequest{
    var mb_idx:String?
    var find_type:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/account/jsonSendEmail.do")
    }
    
    override func setArg() {
        arg["mb_idx"] = mb_idx!
        arg["find_type"] = find_type ?? "2"
    }
}
