//
//  CoinHogaEventListener.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/29.
//

import Foundation
import FirebaseDatabase

class CoinHogaEventListener{
    
    
    var appInfo:APPInfo?
    var coinVo:CoinVo?
    var listener:FirebaseInterface?
    var mRef:DatabaseReference?
    var handler:UInt?
    
    var onDataChange: ((DataSnapshot) -> Void)?
    
    init(_ appInfo:APPInfo,_ listener:FirebaseInterface){
        self.appInfo = appInfo
        self.listener = listener
        setOnDataChange()
    }
    
    init(_ coinVo:CoinVo,_ listener:FirebaseInterface){
        self.coinVo = coinVo
        self.listener = listener
        setOnDataChange()
    }
    
    func getCoinVo() -> CoinVo{
        return coinVo!
    }
    
    func setCoinVo(_ coinVo:CoinVo){
        self.coinVo = coinVo
    }
    
    func setOnDataChange(){
        onDataChange = {[weak self] snapshot in
            if let data = snapshot.value as? [String:AnyObject]{
                if let _ = self?.coinVo{
                    self?.coinVo?.setFirebaseHoga(f: FirebaseHoga(data as NSDictionary))
                    if let _ = self?.listener{
                        self?.listener?.onDataChange(market: self?.coinVo?.coin_code ?? "ERR")
                    }
                }
                
                if let _ = self?.appInfo{
                    self?.appInfo?.setFirebaseHoga(f: FirebaseHoga(data as NSDictionary))
                    if let _ = self?.listener{
                        self?.listener?.onDataChange(market: "ALL")
                    }
                }
            }
        }
    }
}
