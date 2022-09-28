//
//  FirebaseHoga.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/05.
//

import Foundation

class FirebaseHoga{
    var data : NSDictionary
    init(_ dictionary : NSDictionary){
        self.data = dictionary;
    }
    
    func getHPGACONTRACT() -> [String:Any]?{
        if let data = data["HOGACONTRACT"]{
            return data as? [String : Any]
        }else{
            return nil
        }
    }
    
    func getHOGASUB() -> [String:Any]?{
        if let data = data["HOGASUB"]{
            return data as? [String : Any]
        }else{
            return nil
        }
    }
}
