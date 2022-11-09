//
//  VersionCheckResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/04.
//

import Foundation

struct VersionCheckResponse{
    let baseResponce: BaseResponse
    
    func isSuccess() -> Bool{
        let result : String? = getResult() ?? "9999"
        if result! == "0000"{
            return true
        }
        return false
    }
    
    func isNewVersion() -> Bool{
        let map = baseResponce.data["result"] as? NSDictionary
        let version = map?["versionName"] as? String ?? "1.0.0"
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        
        return VersionUtils.compare(left: appVersion, right: version) != 0
    }
    
    func isRequireUpdate() -> Bool{
        let map = baseResponce.data["result"] as? NSDictionary
        let forceYn = map?["forceYn"] as? String ?? "N"
        if(forceYn == "Y"){
            return true
        }
        return false
    }
    
    func getResult() -> String?{
        return baseResponce.data["code"] as? String
    }
    
    func getFoceYn() -> String?{
        let map = baseResponce.data["result"] as? NSDictionary
        return map?["forceYn"] as? String
    }
    
    func getMsg() -> String?{
        return baseResponce.data["message"] as? String
    }
}
