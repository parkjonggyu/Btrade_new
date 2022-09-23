//
//  KycAccountAuthRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/03.
//


import Foundation
import Alamofire

class KycAccountAuthRequest : BaseRequest{
    var auth_code:String?
    var verify_tr_dt:String?
    var verify_tr_no:String?
    var user_nm:String?
    var fnni_cd:String?
    var bank_name:String?
    var acct_no:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/kycauth/kycAccountAuth.do")
    }
    
    override func setArg() {
        arg["auth_code"] = auth_code ?? ""
        arg["verify_tr_dt"] = verify_tr_dt ?? ""
        arg["verify_tr_no"] = verify_tr_no ?? ""
        arg["user_nm"] = user_nm ?? ""
        arg["fnni_cd"] = fnni_cd ?? ""
        arg["bank_name"] = bank_name ?? ""
        arg["acct_no"] = acct_no ?? ""
    }
}

