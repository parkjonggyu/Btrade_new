//
//  APPInfo.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/04.
//

import Foundation
import FirebaseDatabase

class APPInfo:FirebaseInterface{
    
    
    static var appInfo : APPInfo? = nil;
    var isKycVisible:Bool = false;
    
    
    
    var COINLIST:Array<CoinVo> = Array<CoinVo>()
    func getCoinList() -> Array<CoinVo>{return COINLIST}
    func setCoinList(array:Array<MarketListResponse.Coin>){
        COINLIST = Array<CoinVo>()
        for data in array {
            let item : CoinVo = CoinVo(coin: data);
            COINLIST.append(item)
        }
        if let _ = coinHogaEventListener{
            FirebaseDatabaseHelper.getInstance().removeListener(hogaEventListener: coinHogaEventListener!)
            FirebaseDatabaseHelper.getInstance().onHogaBTC(coinHogaEventListener!, COINLIST)
        }
        if let _ = firebaseKRWInterface{
            FirebaseDatabaseHelper.getInstance().removeListener(firebaseKRWInterface: firebaseKRWInterface!)
            FirebaseDatabaseHelper.getInstance().onCommon(firebaseKRWInterface!)
        }
        
        
        
    }
    
    
    var krwValue:Decimal?
    func setKrwValue(krw:Decimal){self.krwValue = krw}
    func getKrwValue() -> Decimal?{return krwValue}
    
    
    var coinHogaEventListener:CoinHogaEventListener?
    var firebaseKRWInterface:CoinKrwEventListener?
    
    init(){
        let _ = setLoginCookies(cookies: HTTPCookieStorage.shared.cookies)
        coinHogaEventListener = CoinHogaEventListener(self, self)
        firebaseKRWInterface = CoinKrwEventListener(self)
    }
    
    static func getInstance() -> APPInfo{
        if(appInfo == nil){
            appInfo = APPInfo()
        }
        return appInfo!
    }
    
    
    
    var dataSnapshot:DataSnapshot?
    func getDataSnapShot() -> DataSnapshot?{return dataSnapshot}
    func setDataSnapShot(data:DataSnapshot){self.dataSnapshot = data}
    
    
    var allFirebaseHoga:FirebaseHoga?
    func setFirebaseHoga(f:FirebaseHoga){self.allFirebaseHoga = f}
    func getFirebaseHoga() -> FirebaseHoga?{return self.allFirebaseHoga}
    
    var krwInterface:ValueEventListener?
    func getKrwInterface() -> ValueEventListener?{return krwInterface}
    func setKrwInterface(_ krw:ValueEventListener){
        self.krwInterface = krw
        if let data = dataSnapshot{self.krwInterface?.onDataChange(snapshot: data)}
    }
    
    func getIsLogin() -> Bool{return setLoginCookies(cookies: HTTPCookieStorage.shared.cookies)}
    func setLoginCookies(cookies:[HTTPCookie]?) -> Bool{
        guard let datas = cookies else {return false}
        for cookie in datas{
            if cookie.name == "loginCookie"{
                return true
            }
        }
        return false
    }
    func deleteCookie(){self.memberInfo = nil}
    
    
    var memberInfo:MemberInfo?
    func getMemberInfo() -> MemberInfo?{return memberInfo}
    func setMemberInfo(_ memberInfo:MemberInfoResponse){
        if let state = memberInfo.getState(){
            if(state == "401"){
                self.memberInfo = nil
                return
            }
        }
        self.memberInfo = memberInfo.getObject()
    }
    
    
    var btcInterface:FirebaseInterface?
    
    func getBtcInterface() -> FirebaseInterface?{return btcInterface}
    func setBtcInterface(_ btc:FirebaseInterface){
        self.btcInterface = btc
        if let _ = getFirebaseHoga(){self.btcInterface?.onDataChange(market: "ALL")}
    }
    
    func onDataChange(market: String) {
        if let _ = btcInterface{
            btcInterface?.onDataChange(market:market)
        }
    }
}
