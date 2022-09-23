//
//  BaseRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/06/30.
//

import Foundation
import Alamofire

class BaseRequest{
    let METHOD : HttpMethod
    let DOMAIN : String
    let URL : String
    init(_ method:HttpMethod,_ domain:String,_ url:String){
        self.METHOD = method
        self.DOMAIN = domain
        self.URL = url
    }
    
    func setArg(){
        
    }
    
    func getMethod() -> HttpMethod{
        return self.METHOD
    }
    
    func getURL() -> String{
        return DOMAIN + self.URL
    }
    
    func getDomain() -> String{
        return self.DOMAIN
    }
    
    var arg = [String : Any]()
    var multipartFormData:MultipartFormData?
    var data:Data?
}

enum HttpMethod{
    case post
    case get
    case image
}
