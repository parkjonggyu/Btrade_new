//
//  CoinVo.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/04.
//

import Foundation

class CoinVo{
    var coin_code:String
    var en_coin_name:String
    var kr_coin_name:String
    var sort:String
    var lastLoadedItem:String?
    var firebaseHoga:FirebaseHoga?
    
    var isInit:Bool = false
    
    init(coin:MarketListResponse.Coin){
        self.coin_code = coin.coin_code
        self.en_coin_name = coin.en_coin_name
        self.kr_coin_name = coin.coin_kr
        self.sort = coin.sort
    }
    
    func setFirebaseHoga(f:FirebaseHoga){
        self.firebaseHoga = f;
    }
}
