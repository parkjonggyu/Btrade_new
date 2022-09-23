//
//  BaseResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/01.
//

import Foundation

class BaseResponse{
    var data : NSDictionary
    var request : Any
    init(dictionary : NSDictionary, request : Any){
        self.data = dictionary;
        self.request = request;
    }
}

extension NSDictionary {
  
  var swiftDictionary: [String : AnyObject] {
    var swiftDictionary: [String : AnyObject] = [:]
    let keys = self.allKeys.flatMap { $0 as? String }
    for key in keys {
      let keyValue = self.value(forKey: key) as AnyObject
      swiftDictionary[key] = keyValue
    }
    return swiftDictionary
  }
}
