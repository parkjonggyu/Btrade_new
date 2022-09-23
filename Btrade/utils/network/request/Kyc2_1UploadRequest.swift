//
//  Kyc2_1UploadRequest.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/28.
//

import Foundation
import Alamofire

class Kyc2_1UploadRequest : BaseRequest{
    var idUploadfile:Data?
    init(){
        super.init(HttpMethod.image, BuildConfig.SERVER_URL, "m/kycauth/ekycOCR.do")
    }
    
    override func setArg() {
        if(idUploadfile != nil){
            multipartFormData = MultipartFormData()
            multipartFormData?.append(idUploadfile!, withName: "idUploadfile", fileName: "idUploadfile.jpeg", mimeType: "image/jpeg")
        }
    }
}

