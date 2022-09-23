//
//  APPInfo.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/04.
//

import Foundation

class APPInfo{
    static var appInfo : APPInfo? = nil;
    var isKycVisible:Bool = false;
    
    var allFirebaseHoga:FirebaseHoga?
    
    var COINLIST:Array<CoinVo> = Array<CoinVo>()
    init(){
        setLoginCookies(cookies: HTTPCookieStorage.shared.cookies)
    }
    
    static func getInstance() -> APPInfo{
        if(appInfo == nil){
            appInfo = APPInfo()
        }
        return appInfo!
    }
    
    func setCoinList(array:Array<MarketListResponse.Coin>){
        COINLIST = Array<CoinVo>()
        for data in array {
            let item : CoinVo = CoinVo(coin: data);
            COINLIST.append(item)
        }    
    }
    
    func getCoinList() -> Array<CoinVo>{
        return COINLIST
    }
    
    func setFirebaseHoga(f:FirebaseHoga){
        self.allFirebaseHoga = f;
    }
    
    func getIsLogin() -> Bool{
        return setLoginCookies(cookies: HTTPCookieStorage.shared.cookies);
    }
    
    func setLoginCookies(cookies:[HTTPCookie]?) -> Bool{
        guard let datas = cookies else {return false}
        for cookie in datas{
            if cookie.name == "loginCookie"{
                return true
            }
        }
        return false
    }
    
    func deleteCookie(){
        self.memberInfo = nil
    }
    
    var memberInfo:MemberInfo?
    
    func setMemberInfo(_ memberInfo:MemberInfoResponse){
        if let state = memberInfo.getState(){
            if(state == "401"){
                self.memberInfo = nil
                return
            }
        }
        
        self.memberInfo = memberInfo.getObject()
    }
    
    func getMemberInfo() -> MemberInfo?{
        return memberInfo
    }
}
