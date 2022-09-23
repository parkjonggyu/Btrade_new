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
    var listener : FirebaseInterface?
    var mMarkets = [String : FirebaseDatabaseItem]()
    let lock = NSLock()
    
    static func getInstance() -> FirebaseDatabaseHelper{
        if mInstance == nil {
            mInstance = FirebaseDatabaseHelper()
        }
        return mInstance!
    }
    
    init(){
        mDatabase = Database.database(url: BuildConfig.FIREBASE_URL).reference()
    }
    
    func setMarkets(_ markets:Array<CoinVo>){
        mMarkets = [String : FirebaseDatabaseItem]()
        for coin in markets{
            mMarkets[coin.coin_code] = FirebaseDatabaseItem(coin)
        }
    }
    
    func onHogaBTC(_ listener:FirebaseInterface, _ markets:Array<CoinVo>){
        self.setMarkets(markets)
        self.listener = listener
        lock.lock()
        if(markets.count > 0){
            FirebaseDatabaseItem(markets[0]).onHogaBTC(listener: listener)
        }else{
            listener.onDataChange(market: "ERROR")
        }
            
        lock.unlock()
    }
    
    func onChart(listener:FirebaseInterface, markets:Array<CoinVo>, INTERVAL:String, coinVo:CoinVo){
        setMarkets(markets)
        self.listener = listener
        lock.lock()
        for data in mMarkets{
            if let item = coinVo.lastLoadedItem{
                data.value.onNextChart(listener:self, INTERVAL:INTERVAL, lastLoadedItem: item)
            }else{
                data.value.onChart(listener:self, INTERVAL:INTERVAL)
            }
        }
        lock.unlock()
    }
    
    func removeObserve(){
        mDatabase!.removeAllObservers()
    }
    
    
    func onDataChange(market: String) {
        self.listener?.onDataChange(market: market)
    }
    
    
}
