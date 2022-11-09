//
//  WithdepHistoryRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/24.
//

import Foundation

class WithdepHistoryRequest : BaseRequest{
    var page_no:String?
    var startExc:String?
    var endExc:String?
   
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "record/searchExcList.do")
    }
    
    override func setArg() {
        if let _ = page_no{arg["page_no"] = page_no!}
        if let _ = startExc{arg["startExc"] = startExc!}
        if let _ = endExc{arg["endExc"] = endExc!}
    }
}

