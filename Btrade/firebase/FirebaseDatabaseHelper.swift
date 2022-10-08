//
//  FirebaseDatabaseHelper.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/05.
//

import Foundation
import FirebaseDatabase

class FirebaseDatabaseHelper:FirebaseInterface{
    
    static var mInstance : FirebaseDatabaseHelper?
    var mDatabase : DatabaseReference?
    var mMarkets = [String : FirebaseDatabaseItem]()
    
    static func getInstance() -> FirebaseDatabaseHelper{
        if mInstance == nil {
            mInstance = FirebaseDatabaseHelper()
        }
        return mInstance!
    }
    
    init(){
        mDatabase = Database.database(url: BuildConfig.FIREBASE_URL).reference()
    }
    
    func onHogaBTC(_ hogaEventListener:CoinHogaEventListener, _ markets:Array<CoinVo>){
        if(markets.count > 0){
            FirebaseDatabaseItem(markets[0]).onHogaBTC(listener: hogaEventListener)
        }
    }
    
    func onCommon(_ firebaseKRWInterface:CoinKrwEventListener){
        if let _ = mDatabase{
            firebaseKRWInterface.setmRef(mDatabase!)
            firebaseKRWInterface.handler = mDatabase?.child("hoga/KRW/BTC/HOGASUB/PRICE_NOW").observe(.value, with: firebaseKRWInterface.onDataChange)
        }
    }
    
    func onChart(_ valueEventListener:ValueEventListener,_ query:String,_ market:String,_ coin:String){
        mDatabase?.child("chart/" + query + "/" + market + "/" + coin).queryOrderedByKey().queryLimited(toLast: 300).getData(completion:  { error, snapshot in
            guard error == nil else {
              print(error!.localizedDescription)
              return;
            }
            if let s = snapshot{
                valueEventListener.onDataChange(snapshot: s)
                return
            }
          });
    }
    
    func removeListener(hogaEventListener:CoinHogaEventListener){
        if let _ = hogaEventListener.handler, let _ = hogaEventListener.mRef{
            hogaEventListener.mRef?.removeObserver(withHandle: hogaEventListener.handler!)
        }
    }
    
    func removeListener(firebaseKRWInterface:CoinKrwEventListener){
        if let mRef = firebaseKRWInterface.getmRef(), let handler = firebaseKRWInterface.handler{
            mRef.removeObserver(withHandle: handler)
        }
    }
    
    func onDataChange(market: String) {
        //self.listener?.onDataChange(market: market)
    }
    
    
}
