//
//  Kyc3UploadRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/02.
//

import Foundation
import Alamofire

class Kyc3UploadRequest : BaseRequest{
    var work_nm:String?
    var job_ds_c:String?
    var work_addr_display_div:String?
    var work_post_no:String?
    var work_addr:String?
    var work_dtl_addr:String?
    var tran_fund_source_div:String?
    var tran_fund_source_nm:String?
    var account_new_purpose_cd:String?
    var account_new_purpose_nm:String?
    var actlownr_yn:String?
    var job_dtl_ds_c:String?
    var bzmn_bzc_ds_c:String?
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/kycauth/kycWorkInfo.do")
    }
    
    override func setArg() {
        arg["work_nm"] = work_nm ?? ""
        arg["job_ds_c"] = job_ds_c ?? ""
        arg["work_addr_display_div"] = work_addr_display_div ?? ""
        arg["work_post_no"] = work_post_no ?? ""
        arg["work_addr"] = work_addr ?? ""
        arg["work_dtl_addr"] = work_dtl_addr ?? ""
        arg["tran_fund_source_div"] = tran_fund_source_div ?? ""
        arg["tran_fund_source_nm"] = tran_fund_source_nm ?? ""
        arg["account_new_purpose_cd"] = account_new_purpose_cd ?? ""
        arg["account_new_purpose_nm"] = account_new_purpose_nm ?? ""
        arg["actlownr_yn"] = actlownr_yn ?? ""
        arg["job_dtl_ds_c"] = job_dtl_ds_c ?? ""
        arg["bzmn_bzc_ds_c"] = bzmn_bzc_ds_c ?? ""
    }
}

