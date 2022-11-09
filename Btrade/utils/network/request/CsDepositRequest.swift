//
//  CsDepositRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/25.
//

import Foundation

class CsDepositRequest : BaseRequest{
    var page_no:String?
    var startExc:String?
    var endExc:String?
    var coin_code:String?
    var csstatus:String?
   
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "record/csdeposit.do")
    }
    
    override func setArg() {
        if let _ = page_no{arg["page_no"] = page_no!}
        if let _ = startExc{arg["startExc"] = startExc!}
        if let _ = endExc{arg["endExc"] = endExc!}
        if let _ = coin_code{arg["coin_code"] = coin_code!}
        if let _ = csstatus{arg["csstatus"] = csstatus!}
    }
}


