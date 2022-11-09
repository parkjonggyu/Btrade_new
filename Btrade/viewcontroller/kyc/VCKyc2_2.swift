//
//  VCKyc2_2.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/31.
//

import UIKit
import Alamofire

class VCKyc2_2: VCBase, CameraResult {
    var mKyc:Dictionary<String, Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func goNext(_ sender: Any) {
        if let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kyc2cameravc") as? VCKyc2Camera{
            pushVC.delegate = self
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
    func result(_ data : Data?){
        if let image = data{
            let request = Kyc2_1UploadRequest()
            request.idUploadfile = image
            ApiFactory(apiResult: self, request: request).newThread()
        }else{
            self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요.")
        }
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? Kyc2_1UploadRequest{
            let data = Kyc2_1UploadResponse(baseResponce: response)
            DispatchQueue.main.async{
                guard let message = data.getMessage() , let _ = self.mKyc else {
                    self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                    return
                }
                if message == "SUCCESS"{
                    if let rnm_no_div = data.getRnm_no_div(){
                        if(!self.checkJuminNumber(data)){
                            self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                            return
                        }
                        
                        self.mKyc?["rnm_no_div"] = rnm_no_div
                        self.mKyc?["photo1"] = data.getFilePath()
                        self.mKyc?["requestId"] = data.getRequestId()
                        if let front = self.mKyc?["yyyymmdd"] as? String{
                            self.mKyc?["identity1"] = front
                        }
                        self.mKyc?["identity2"] = data.getPersonalNum_back()
                        
                        if self.mKyc?["photo1"] == nil || self.mKyc?["requestId"] == nil || self.mKyc?["identity1"] == nil || self.mKyc?["identity2"] == nil {
                            self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                            return
                        }
                        self.mKyc?["rnm_no_div"] = rnm_no_div
                        
                        if(rnm_no_div == "01"){
                            if let year:String = data.getIssueDate_year(),let mon:String = data.getIssueDate_month() ,let day:String = data.getIssueDate_day(){
                                self.mKyc?["issue_date"] = self.makeIssueDate(year, mon, day)
                            }
                        }else if(rnm_no_div == "99"){
                            self.mKyc?["issue_date"] = data.getNum()
                            self.mKyc?["drivecode"] = data.getCode()
                        }else{
                            self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                            return
                        }
                        self.nextStep()
                        return
                    }
                }
                
                self.showErrorDialog("인식에 실패했습니다. 다시 실행해 주세요.")
            }
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    fileprivate func nextStep(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kyc2_1vc") as? VCKyc2_1
        pushVC?.mKyc = mKyc
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    fileprivate func makeIssueDate(_ year:String,_ mon_:String,_ day_:String) -> String{
        var mon = ""
        var day = ""
        if(mon_.count == 1){mon = "0" + mon_}
        if(day_.count == 1){day = "0" + day_}
        
        return year + "-" + mon + "-" + day
    }
    
    fileprivate func checkJuminNumber(_ data:Kyc2_1UploadResponse) -> Bool{
        if let front = self.mKyc?["yyyymmdd"] as? String, let back = data.getPersonalNum_back(){
            guard let _ = Int(front) else {return false}
            guard let _ = Int(back) else {return false}
            
            let juminNo = front + back
            
            if(juminNo.count != 13){return false}
            
            let LOGIC_MUM = [2,3,4,5,6,7,8,9,2,3,4,5]
            var sum = 0

            for i in 0 ..< LOGIC_MUM.count{
                sum += LOGIC_MUM[i] * getCharacter(juminNo,i)
            }

            let checkNum = (11 - sum % 11) % 10

            return (checkNum == (getCharacter(juminNo,juminNo.count - 1)))
        }
        return false
    }
    
    func getCharacter(_ j:String, _ idx:Int ) -> Int{
        let c = j.substring(from:idx, to:idx+1)
        return Int(c) ?? 0
    }
}


protocol CameraResult:AnyObject{
    func result(_: Data?)
}
