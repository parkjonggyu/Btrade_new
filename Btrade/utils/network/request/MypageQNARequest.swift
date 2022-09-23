//
//  MypageQNARequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/22.
//

import Foundation
import Alamofire

class MypageQNARequest : BaseRequest{
    var bq_type:String?
    var bq_category:String?
    var bq_title:String?
    var bq_contents:String?
    var bq_pw:String?
    var attach_image:String?
    var bq_writer:String?
    var bq_tel:String?
    var os:String = "ANDROID"
    var bq_idx:String?
    var bq_nick_name:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "board/qnaboard_insertBoard.do")
    }
    
    override func setArg() {
        arg["bq_type"] = bq_type ?? "1"
        if let _ = bq_category{ arg["bq_category"] = bq_category! }
        if let _ = bq_title{ arg["bq_title"] = bq_title! }
        if let _ = bq_contents{ arg["bq_contents"] = bq_contents! }
        arg["bq_pw"] = bq_pw ?? ""
        arg["attach_image"] = attach_image ?? ""
        if let _ = bq_writer{ arg["bq_writer"] = bq_writer! }
        if let _ = bq_tel{ arg["bq_tel"] = bq_tel! }
        arg["os"] = os
        if let _ = bq_idx{ arg["bq_idx"] = bq_idx! }
        if let _ = bq_nick_name{ arg["bq_nick_name"] = bq_nick_name! }
    }
}
