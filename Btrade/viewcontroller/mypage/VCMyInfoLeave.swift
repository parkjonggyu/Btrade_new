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
        if let _ = response.request as? MypageCheckPasswordRequest{
            let data = MypageCheckPasswordResponse(baseResponce: response)
            if let result = data.getStatus() {
                if(result == "success"){
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "myinfochangepassword2vc") as? VCMyInfoChangePassword2 else {
                        return
                    }
                    
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                    return;
                }
            }
                
            self.showErrorDialog("비밀번호가 올바르지 않습니다.")
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
}

