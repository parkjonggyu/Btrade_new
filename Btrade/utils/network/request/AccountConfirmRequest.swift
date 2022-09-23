//
//  AccountConfirmRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/03.
//

import Foundation
import Alamofire

class AccountConfirmRequest : BaseRequest{
    var user_nm:String?
    var jumin_no:String?
    var fnni_cd:String?
    var acct_no:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/kycauth/kycAccountConfirm.do")
    }
    
    override func setArg() {
        arg["user_nm"] = user_nm ?? ""
        arg["jumin_no"] = jumin_no ?? ""
        arg["fnni_cd"] = fnni_cd ?? ""
        arg["acct_no"] = acct_no ?? ""
    }
}
