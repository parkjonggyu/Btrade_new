//
//  VCSignupAuth.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/13.
//

import Foundation
import UIKit
import Alamofire

class VCSignupAuth: VCBase , AuthTimerInterface{
    
    

    @IBOutlet weak var mEmailText: UILabel!
    @IBOutlet weak var mTimerText: UILabel!
    @IBOutlet weak var mAuthText: UITextField!
    
    var ID:String?
    var PW:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mAuthText.delegate = self
        if ID == nil || PW == nil{
            goBack()
            return
        }
        mEmailText.text = ID
        initTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.stop()
    }
    
    var timer:AuthTimer?
    func initTimer(){
        timer = AuthTimer(1000*60*10, self, mTimerText)
        timer?.start()
    }
    
    
    @IBAction func startAuth(_ sender: Any) {
        let AUTH = mAuthText.text!
        if(AUTH.count != 6){
            showErrorDialog("인증 번호 6자리를 입력해 주세요")
            return
        }
        
        var request = SignupAuthRequest()
        request.email = ID
        request.token = AUTH
        ApiFactory(apiResult: self, request: request).netThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? SignupAuthRequest{
            let data = SignupAuthResponse(baseResponce: response)
            if let code = data.getCode(){
                if(code == "200"){
                    nextPage()
                    return
                }
                if(code == "400" || code == "9999"){
                    if let msg = data.getMsg(){
                        showErrorDialog(msg)
                        return
                    }
                }
            }
            showErrorDialog("인증에 실패했습니다.")
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        print(e)
    }
    
    func nextPage(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "signupcompletevc") 
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        goBack()
    }
    
    func goBack(){
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is VCLogin {
                _ = self.navigationController?.popToViewController(vc as! VCLogin, animated: true)
                return
            }
        }
        self.navigationController?.dismiss(animated: true)
    }
    
    func endTimer() {
        DialogUtils().makeDialog(
            uiVC: self,
            title: "알림",
            message:"인증 시간이 자났습니다. 다시 시도하세요.",
            UIAlertAction(title: "확인", style: .default) { (action) in
                self.goBack()
            })
    }
}


extension VCSignupAuth: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "signupauth"){
                if((textField.text! + string).count > 6 && string.count > 0){ return false }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let _ = textField.restorationIdentifier{
            textField.background = UIImage(named: "text_field_active.png")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _ = textField.restorationIdentifier{
            textField.background = UIImage(named: "text_field_inactive.png")
        }
    }
}
