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
    
    func getHPGACONTRACT(_ coinCode:String) -> [String:Any]?{
        if let coin = data[coinCode] as? [String : Any]{
            if let data = coin["HOGACONTRACT"]{
                return data as? [String : Any]
            }
        }
        return nil
    }
    
    func getHPGACONTRACT() -> [String:Any]?{
        if let data = data["HOGACONTRACT"]{
            return data as? [String : Any]
        }
        return nil
    }
    
    func getHOGASUB(_ coinCode:String) -> [String:Any]?{
        if let coin = data[coinCode] as? [String : Any]{
            if let data = coin["HOGASUB"]{
                return data as? [String : Any]
            }
        }
        return nil
    }
    
    func getHOGASUB() -> [String:Any]?{
        if let data = data["HOGASUB"]{
            return data as? [String : Any]
        }
        return nil
    }
    
    func getHOGA(_ coinCode:String) -> [String:Any]?{
        if let coin = data[coinCode] as? [String : Any]{
            if let data = coin["HOGA"]{
                return data as? [String : Any]
            }
        }
        return nil
    }
    
    func getHOGA() -> [String:Any]?{
        if let data = data["HOGA"]{
            return data as? [String : Any]
        }
        return nil
    }
}
