//
//  ApiFactory.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/06/30.
//

import Foundation
import Alamofire

class ApiFactory{
    let apiResult : AnyObject?
    let request : BaseRequest
    init(apiResult:AnyObject, request:BaseRequest){
        self.apiResult = apiResult
        self.request = request
    }
    
    func netThread(){
        if(request.getDomain() == BuildConfig.SERVER_URL || request.getDomain() == BuildConfig.SERVER_API_URL || request.getDomain() == BuildConfig.SERVER_PC_URL){
            request.setArg()
            vcLoadingStart()
            switch request.getMethod(){
                case .get:
                    get()
                case .post:
                    post()
                case .image:
                    image()
                default :
                    self.error();
            }
            
        }
    }
    
    func get(){
        let headers:HTTPHeaders? = HTTPHeaders(["User-Agent" : getUserAgent(),
                        "Content-Type":"application/x-www-form-urlencoded",
                       "X-Requested-With":"XMLHttpRequestNative"])
        AF.request(request.getURL(),method: .get, parameters: request.arg, headers: headers).responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                if let temp = obj as? NSDictionary{
                    self.success(temp)
                    return;
                }
                if let temp = obj as? NSArray{
                    self.success(temp)
                    return;
                }
                self.error();
            case .failure(let error):
                self.error(error)
            }
        }
    }
    
    func post(){
        print(request.arg)
        let headers:HTTPHeaders? = HTTPHeaders(["User-Agent" : getUserAgent(),
                        "Content-Type":"application/x-www-form-urlencoded",
                       "X-Requested-With":"XMLHttpRequestNative"])
        AF.request(request.getURL(),method: .post, parameters: request.arg, headers: headers).responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                if let temp = obj as? NSDictionary{
                    print(temp)
                    self.success(temp)
                    return;
                }
                self.error();
            case .failure(let error):
                self.error(error)
            }
        }
    }
    
    func image(){
        let headers:HTTPHeaders? = HTTPHeaders(["User-Agent" : getUserAgent(),
                        "Content-Type":"multipart/form-data",
                       "X-Requested-With":"XMLHttpRequestNative"])
        guard let multiData = request.multipartFormData else {
            self.error()
            return
        }
        AF.upload(multipartFormData: multiData, to: request.getURL(), usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                if let temp = obj as? NSDictionary{
                    print(temp)
                    self.success(temp)
                    return;
                }
                self.error();
            case .failure(let error):
                self.error(error)
            }
        }
    }
    
    
    func vcLoadingStart(){
        if let progressInterface = apiResult as? ProgressInterface {
            progressInterface.startProgress()
        }
    }
    
    func vcLoadingEnd(){
        if let progressInterface = apiResult as? ProgressInterface {
            progressInterface.endProgress()
        }
    }
    
    func success(_ data : NSDictionary){
        if let result = apiResult as? ApiResult {
            result.onResult(response: BaseResponse(dictionary: data, request: request));
        }
        vcLoadingEnd()
    }
    
    func success(_ data : NSArray){
        if let result = apiResult as? ApiResult {
            let response = BaseResponse(dictionary: [:], request: request)
            response.data = ["array":data]
            result.onResult(response: response);
        }
        vcLoadingEnd()
    }
    
    func error(_ error : AFError){
        print(error)
        vcLoadingEnd()
        if let result = apiResult as? ApiResult {
            result.onError(e: error, method: "")
        }
        
    }
    
    func error(){
        print("unkwon error")
        if let vc = apiResult as? VCBase {
            vc.showErrorDialog("네트워크 통신에 실패했습니다. 잠시후 다시 시도하세요.")
        }
        vcLoadingEnd()
    }
    
    func getUserAgent() -> String{
        return "BTrade/" + BuildConfig.VERSION_NAME + " (IPhone;" + getOsVersion() + ";" + getModel()  + ")"
    }
    
    func getOsVersion() -> String {
        return UIDevice.current.systemVersion
    }

    func getModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return model
    }
}


