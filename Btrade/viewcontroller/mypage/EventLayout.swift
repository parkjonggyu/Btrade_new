//
//  EventLayout.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/30.
//

import Foundation
import Alamofire
import UIKit
import ImageSlideshow

class EventLayout: ApiResult{
    var vcMypage:VCMypage!
    var height:CGFloat?
    
    var mArray:Array<Event> = Array()
    
    let images = [
        AlamofireSource.init(urlString: "https://www.btrade.co.kr/2.png", placeholder: UIImage(named: "eventtest.png"))!,
        AlamofireSource.init(urlString: "https://www.btrade.co.kr/2.png", placeholder: UIImage(named: "eventtest.png"))!,
    ]
    
    init(_ vcMypage:VCMypage){
        self.vcMypage = vcMypage
        height = vcMypage.myPageEventHeight.constant
    }
    
    func start(){
        vcMypage.myPageEventHeight.constant = 0
        
        let request = MypageEventRequest()
        request.query = ""
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    func onResult(response: BaseResponse) {
        if let _ = response.request as? MypageEventRequest{
            let response = MypageEventResponse(baseResponce: response)
            if let json = response.getEvents(){
            
            }
            DispatchQueue.main.async{
                self.startIamge()
            }
        }
    }
    
    func onError(e: AFError, method: String) { }
    
    fileprivate func startIamge(){
        vcMypage.myPageEventHeight.constant = height!
        vcMypage.myPageEvent.setImageInputs(images)
    }
}

struct Event{
    var be_idx:String?
    var title:String?
    var status:String?
    var start_date:String?
    var end_date:String?
    var banner_start_date:String?
    var banner_end_date:String?
    var mobile_banner_image:String?
    var mobile_content:String?
    var reg_date:String?
}
