//
//  FirebaseDatabaseItem.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/05.
//

import Foundation
import FirebaseDatabase

class FirebaseDatabaseItem{
    var coinVo:CoinVo
    var mRef:DatabaseReference
    var LIMIT:Int = 100
    var listener:FirebaseInterface?
    
    init(_ coinVo:CoinVo){
        self.coinVo = coinVo
        mRef = FirebaseDatabaseHelper.getInstance().mDatabase!
    }
    
    func onHogaBTC(listener:FirebaseInterface){
        self.listener = listener
        mRef.child("hoga/BTC/").observe(.value){(snapshot) in
            let data = snapshot.value as? [String:AnyObject]
            if data != nil {
                APPInfo.getInstance().setFirebaseHoga(f: FirebaseHoga(data! as NSDictionary))
                self.listener?.onDataChange(market: "ALL")
            }
        }
    }
    
    func onChart(listener:FirebaseInterface, INTERVAL:String) {
        self.listener = listener
        if(INTERVAL == "MIN" || INTERVAL == "3MIN" || INTERVAL == "5MIN"){
            LIMIT = 1
        }
        mRef.child("chart/" + INTERVAL + "/BTC/" + coinVo.coin_code).queryOrderedByKey().queryLimited(toLast: UInt(LIMIT)).observeSingleEvent(of: .value){(snapshot) in
            let data = snapshot.value as? [String:AnyObject]
            if data != nil {
                self.coinVo.setFirebaseHoga(f: FirebaseHoga(data! as NSDictionary))
            }
        }
        
        mRef.child("chart/" + INTERVAL + "/BTC/" + coinVo.coin_code).queryOrderedByKey().queryLimited(toLast: UInt(1)).observeSingleEvent(of: .value){(snapshot) in
            
        }
    }
    
    func onNextChart(listener:FirebaseInterface, INTERVAL:String, lastLoadedItem:String) {
        self.listener = listener
        if(INTERVAL == "MIN" || INTERVAL == "3MIN" || INTERVAL == "5MIN"){
            LIMIT = 1
        }
        mRef.child("chart/" + INTERVAL + "/BTC/" + coinVo.coin_code).queryOrderedByKey().queryEnding(atValue: lastLoadedItem).queryLimited(toLast: UInt(LIMIT + 1)).observeSingleEvent(of: .value){(snapshot) in
            
        }
    }
    
    func getCoinVo() -> CoinVo{
        return coinVo
    }
    
}
