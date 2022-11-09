//
//  Kyc2UploadRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/02.
//

import Foundation
import Alamofire

class Kyc2UploadRequest : BaseRequest{
    var key:Data?
    var map:[String:Any]!
    
    init(){
        super.init(HttpMethod.post, BuildConfig.SERVER_URL, "m/kycauth/eKYCApi1.do")
        map = [String:Any]()
    }
    
    override func setArg() {
        if(map != nil){
            arg = map
//           multipartFormData = MultipartFormData()
//            var param : [String:Any] = [:]
//            if let theJSONData = try? JSONSerialization.data(
//                withJSONObject: map!,
//                options: []) {
//                data = theJSONData
//                let theJSONText = String(data: theJSONData,
//                                         encoding: .utf8)!
//                param = ["key" : theJSONText]
//            }
//            
//            multipartFormData?.append("{user:suer}".data(using: .utf8)!, withName: "key")
//            for (key, value) in map {
//                multipartFormData?.append("\(value)".data(using: .utf8)!, withName: key)
//            }
        }
    }
    
    func setKyc2Data(_ data:Dictionary<String, Any>?){
        map["rnm_no_div"] = data?["rnm_no_div"]
        map["name"] = data?["krName"]
        map["requestId"] = data?["requestId"]
        if map["rnm_no_div"] as! String == "01"{//주민등록증
            map["regno_verify"] = (data?["identity1"] as! String) + "-" + (data?["identity2"] as! String)
            map["issue_date"] = data?["issue_date"]
        }else{//운전면허증
            map["regno_verify"] = (data?["identity1"] as? String ?? "") + "-" + (data?["identity2"] as? String ?? "")
            if let s = data?["issue_date"] as? String{
                map["issue_date"] = s
                map["license_no"] = s.replacingOccurrences(of: "-", with: "")
                let temp = s.components(separatedBy: "-")
                if temp.count == 3{
                    map["issue_date_yy"] = temp[0]
                    map["issue_date_mm"] = temp[1]
                    map["issue_date_dd"] = temp[2]
                }
            }
            map["drivecode"] = data?["drivecode"]
        }
        
        map["customer_div"] = "01"
        map["customer_tp_cd"] = "08"
        map["customer_eng_nm"] = (data?["enFirstName"] as! String).replacingOccurrences(of: " ", with: "") + (data?["enLastName"] as! String).replacingOccurrences(of: " ", with: "")
        map["customer_sts_cd"] = "01"
        map["agent_yn"] = "N"
        map["agent_rela_div"] = "NA"
        map["reg_user_id"] = "NA"
        map["last_change_user_id"] = "NA"
        map["rnm_no"] = (data?["identity1"] as? String ?? "") + (data?["identity2"] as? String ?? "")
        map["country_cd"] = "KR"
        map["virt_acct_use_yn"] = "N"
        let live_yn = "Y"
        map["live_yn"] = live_yn
        let foreigner_div = "Y"
        map["foreigner_div"] = foreigner_div
        if(live_yn == "Y"){
            if(foreigner_div == "A"){
                map["aml_ra_cust_indv_cd"] = "01"
                map["aml_live_div"] = "04"
            }else{
                map["aml_ra_cust_indv_cd"] = "04"
                map["aml_live_div"] = "03"
            }
        }else{
            if(foreigner_div == "A"){
                map["aml_ra_cust_indv_cd"] = "03"
                map["aml_live_div"] = "02"
            }else{
                map["aml_ra_cust_indv_cd"] = "05"
                map["aml_live_div"] = "01"
            }
        }
        
        map["kofiu_job_div_cd"] = "91"
        map["live_country_cd"] = "KR"
        map["indv_industry_cd"] = "N"
        map["virtual_money_handle_cd"] = "Y"
        map["reg_user_id"] = "NA"
        map["last_change_user_id"] = "NA"
        map["dept_nm"] = "NN"
        map["posi_nm"] = "NN"
        if(live_yn == "Y"){
            map["live_div_cd"] = "01"
        }else{
            map["live_div_cd"] = "02"
        }
        map["home_addr_country_cd"] = "KR"
        map["home_addr_display_div"] = "KR"
        map["home_post_no"] = data?["zonecode"]
        if let _ = data?["buildingName"]{
            map["home_addr"] = (data?["roadAddress"] as! String) + "(" + (data?["buildingName"] as! String) + ")"
        }else{
            map["home_addr"] = data?["roadAddress"]
        }
        
        map["home_dtl_addr"] = data?["detailAddress"]
        map["aml_customer_indv_cdd"] = "NA"
        map["ceo_yn"] = "N"
        map["real_ownr_yn"] = "Y"
        map["uuid"] = data?["kyc2uuid"]
        
    }
}
