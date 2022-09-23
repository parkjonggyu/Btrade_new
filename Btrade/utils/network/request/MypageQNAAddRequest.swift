//
//  MypageQNAAddRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/23.
//

import Foundation
import Alamofire

class MypageQNAAddRequest : BaseRequest{
    var bq_idx:String?
    var bq_contents:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "board/qnaboard_insertBoardAdd.do")
    }
    
    override func setArg() {
        arg["bq_idx"] = bq_idx ?? ""
        arg["bq_contents"] = bq_contents ?? ""
    }
}

