//
//  WebResult.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/26.
//

import Foundation

protocol WebResult:AnyObject{
    func result(_: Dictionary<String, Any>)
}
