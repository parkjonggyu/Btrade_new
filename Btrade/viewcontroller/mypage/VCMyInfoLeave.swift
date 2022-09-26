//
//  VCMyInfoLeave.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/23.
//

import Foundation
import Alamofire

class VCMyInfoLeave: VCBase {
    
    
    @IBOutlet weak var backBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    @IBAction func onClicked(_ sender: Any) {
        ApiFactory(apiResult: self, request: MyInfoLeaveAssetRequest()).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? MyInfoLeaveAssetRequest{
            let data = MyInfoLeaveAssetResponse(baseResponce: response)
            if let allow = data.getIsAllowed(){
                if(allow == "true"){
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "myinfoleaveasset2") as? VCMyInfoLeaveAsset2 else {
                        return
                    }
                    vc.totalAsset = data.getTotal_assets()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true);
                    return;
                }else{
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "myinfoleaveasset1") as? VCMyInfoLeaveAsset1 else {
                        return
                    }
                    vc.totalAsset = data.getTotal_assets()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true);
                    return;
                }
            }
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
}

