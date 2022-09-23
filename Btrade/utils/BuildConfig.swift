//
//  BuildConfig.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/06/30.
//

import Foundation

class BuildConfig{
    static let DEBUG:Bool = true
    static let APPLICATION_ID : String = "kr.co.btrade"
    static let BUILD_TYPE : String = "debug"
    static let FLAVOR : String = "dev"
    static let VERSION_NAME : String = "1.0"
    
    
//    static let SERVER_URL : String = "https://m.btrade.co.kr/"
//    static let SERVER_API_URL : String = "https://www.btrade.co.kr/"
//    static let SERVER_PC_URL : String = "https://www.btrade.co.kr/"
//    static let IAMGE_URL : String = SERVER_URL + "common/fileRequest.do?filePath="
//    static let FIREBASE_URL : String = "https://btrade-prd.firebaseio.com"
    
    
    static let SERVER_URL : String = "https://devdata.btrade.co.kr/"
    static let SERVER_API_URL : String = "https://devdata.btrade.co.kr/"
    static let SERVER_PC_URL : String = "https://devdata.btrade.co.kr/"
    static let IAMGE_URL : String = SERVER_URL + "common/fileRequest.do?filePath="
    static let FIREBASE_URL : String = "https://btrade-dev.firebaseio.com"
    
    
    
    
    static let STORE_ID : String = "id362057947"
}
