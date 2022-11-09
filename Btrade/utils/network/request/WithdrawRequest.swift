//
//  WithdrawRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/22.
//

import Foundation

class WithdrawRequest : BaseRequest{
    var coinType:String?
    var request_amount:String?
    var to_address:String?
    var to_destination_tab:String?
    var to_memo_tag:String?
    var tradePwCoin:String?
    var code:String?
    var idx:String?
    var beneficiaryVaspId:String?
    var beneficiaryName:String?
    var mb_idx:String?
    var beneficiaryCountry:String?
   
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "finance/jsonCoinOut.do")
    }
    
    override func setArg() {
        if let _ = coinType{arg["coinType"] = coinType!}
        if let _ = request_amount{arg["request_amount"] = request_amount!}
        if let _ = to_address{arg["to_address"] = to_address!}
        if let _ = to_destination_tab{arg["to_destination_tab"] = to_destination_tab!}
        if let _ = to_memo_tag{arg["to_memo_tag"] = to_memo_tag!}
        if let _ = tradePwCoin{arg["tradePwCoin"] = tradePwCoin!}
        if let _ = code{arg["code"] = code!}
        if let _ = idx{arg["idx"] = idx!}
        if let _ = beneficiaryVaspId{arg["beneficiaryVaspId"] = beneficiaryVaspId!}
        if let _ = beneficiaryName{arg["beneficiaryName"] = beneficiaryName!}
        if let _ = mb_idx{arg["mb_idx"] = mb_idx!}
        if let _ = beneficiaryCountry{arg["beneficiaryCountry"] = beneficiaryCountry!}
    }
}
