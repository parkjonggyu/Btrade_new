//
//  BalanceResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/15.
//

import Foundation

struct BalanceResponse{
    let baseResponce: BaseResponse
    
    func getCoinBalance() -> Array<[String:Any]>?{
        let index = "coin_balance"
        if let code = baseResponce.data[index] as? Array<[String:Any]>{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            var list:Array<[String:Any]>?
            do{
                list = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? Array
                return list
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getAddressList() -> Array<[String:Any]>?{
        let index = "addressList"
        if let code = baseResponce.data[index] as? Array<[String:Any]>{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            var list:Array<[String:Any]>?
            do{
                list = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? Array
                return list
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getSymbols() -> Array<String>?{
        let index = "symbols"
        if let code = baseResponce.data[index] as? Array<String>{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            var list:Array<String>?
            do{
                list = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? Array
                return list
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getAddressByState() -> [String:Any]?{
        let index = "addressByState"
        if let code = baseResponce.data[index] as? [String:Any]{
            return code
        }
        
        
        
        if let c = baseResponce.data[index] as? String{
            var list:[String:Any]?
            do{
                list = try JSONSerialization.jsonObject(with: Data(c.utf8), options: []) as? [String:Any]
                return list
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
