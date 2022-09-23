//
//  VCFindPW2.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/14.
//

import Foundation
import UIKit
import Alamofire

class VCFindPWEmail: VCBase{
    
    var result:String?
    var email:String?
    
    @IBOutlet weak var mEmailText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(result == nil || email == nil){
            prePage()
            return
        }
        mEmailText.text = email!
    }
    
    @IBAction func sendMail(_ sender: Any) {
        let request:FindPWSendEmailRequest = FindPWSendEmailRequest()
        request.mb_idx = result
        request.find_type = "2"
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? FindPWSendEmailRequest{
            let data = FindPWSendEmailResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("사용할 수 없는 계정입니다.")
                return
            }
            if(code == "200"){
                nextPage()
                return
            }
        }
        showErrorDialog("사용할 수 없는 계정입니다.")
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    func nextPage(){
        DialogUtils().makeDialog(
            uiVC: self,
            title: "임시 비밀번호",
            message:"임시 비밀번호가 발송 되었습니다",
            UIAlertAction(title: "확인", style: .default) { (action) in
                self.prePage()
            })
    }
    
    @IBAction func goBack(_ sender: Any) {
        prePage()
    }
    
    func prePage(){
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is VCLogin {
                _ = self.navigationController?.popToViewController(vc as! VCLogin, animated: true)
                return
            }
        }
        self.navigationController?.dismiss(animated: true)
    }
}
