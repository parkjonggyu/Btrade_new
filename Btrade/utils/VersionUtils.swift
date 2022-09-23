//
//  VersionUtils.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/04.
//

import Foundation

class VersionUtils{
    static func compare(left:String, right:String) -> Int{
        if(left == right){
            return 0;
        }
        
        let leftarr = left.components(separatedBy: ".")
        let rightarr = right.components(separatedBy: ".")
        
        if leftarr.count != 3 {return 1}
        if rightarr.count != 3 {return 1}
        
        if Int(leftarr[0] ) ?? 1 < Int(rightarr[0] ) ?? 1 {return 1}
        if Int(leftarr[1] ) ?? 1 < Int(rightarr[1] ) ?? 1 {return 1}
        
        return 0
    }
}
