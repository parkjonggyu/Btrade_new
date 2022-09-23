//
//  ApiResult.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/06/30.
//

import Foundation
import Alamofire

protocol ApiResult{
    func onResult(response:BaseResponse)
    func onError(e:AFError, method:String)
}
