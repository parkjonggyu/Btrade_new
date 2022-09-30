//
//  CoinKrwEventListener.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/29.
//

import Foundation
import FirebaseDatabase

class CoinKrwEventListener{
    var appInfo:APPInfo?
    var mRef:DatabaseReference?
    var handler:UInt?
    
    init(_ appInfo:APPInfo){
        self.appInfo = appInfo
    }
    
    var onDataChange: ((DataSnapshot) -> Void) = {snapshot in
        let data = snapshot.value
        if data != nil {
            if let krw = data as? Int64{
                APPInfo.getInstance().setDataSnapShot(data: snapshot)
                APPInfo.getInstance().setKrwValue(krw: DoubleDecimalUtils.newInstance(String(krw)))
                if let listener = APPInfo.getInstance().getKrwInterface(){
                    listener.onDataChange(snapshot: snapshot)
                }
            }
        }
    }
    
    func getmRef() -> DatabaseReference?{return mRef}
    func setmRef(_ r:DatabaseReference){self.mRef = r}
}
