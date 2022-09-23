//
//  VCSignup.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/13.
//

import Foundation
import UIKit
import Alamofire

class VCSignup: VCBase {
    
    @IBOutlet weak var mEditId: UITextField!
    @IBOutlet weak var mEditPw: UITextField!
    @IBOutlet weak var mEditPwCf: UITextField!
    @IBOutlet weak var errormsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mEditId.delegate = self
        mEditPw.delegate = self
        mEditPwCf.delegate = self
    }
    
    @IBAction func backClicked(_ sender: Any) {
        prePage()
    }
    
    func errorCheck() -> Bool{
        if !emailCheck(input:mEditId.text!) { return false }
        if !passwordCheck(input:mEditPw.text!) { return false }
        if mEditPw.text! != mEditPwCf.text! { return false }
        return true
    }
    
    @IBAction func startSignup(_ sender: Any) {
        if !errorCheck(){return}
        
        let request = SignupRequest()
        request.join_id = mEditId.text!
        request.join_password = mEditPw.text!
        request.join_password_ok = mEditPwCf.text!
        ApiFactory(apiResult: self, request: request).newThread()
    }
        
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? SignupRequest{
            let data = SignupResponse(baseResponce: response)
            if let code = data.getCode(){
                if(code == "200"){
                    nextPage()
                    return
                }
                if(code == "-500"){
                    DialogUtils().makeDialog(
                        uiVC: self,
                        title: "알림",
                        message:"이미 가입된 이메일입니다.",
                        UIAlertAction(title: "확인", style: .default) { (action) in
                            self.prePage()
                        })
                    return
                }
                if(code == "-501"){
                    if let msg = data.getMsg(){
                        showErrorDialog(msg)
                        return
                    }
                }
                
            }
            showErrorDialog("회원가입을 하지 못했습니다.")
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        print(e)
    }
    
    func nextPage(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "signupauthvc") as? VCSignupAuth
        
        pushVC?.ID = mEditId.text!
        pushVC?.PW = mEditPw.text!
        self.navigationController?.pushViewController(pushVC!, animated: true)
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


extension VCSignup: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "signupid"){
                if(emailCheck(input:(textField.text! + string))){
                    errormsg.text = ""
                }else{
                    errormsg.text = "아이디(이메일) 형식이 올바르지 않습니다."
                }
                if((textField.text! + string).count > 40 && string.count > 0){ return false }
            }else if(id == "signuppw"){
                if(passwordCheck(input:(textField.text! + string))){
                    errormsg.text = ""
                }else{
                    errormsg.text = "패스워드 형식이 올바르지 않습니다.(영문, 숫자, 특수문자 조합)"
                }
                if((textField.text! + string).count > 15 && string.count > 0){ return false }
            }else if(id == "signuppwcf"){
                if(self.mEditPw.text! == (textField.text! + string)){
                    errormsg.text = ""
                }else{
                    errormsg.text = "패스워드가 같지 않습니다."
                }
                if((textField.text! + string).count > 15 && string.count > 0){ return false }
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
    
    func emailCheck(input:String) -> Bool {
        let pattern = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return true
        }
        return false
    }
    
    func passwordCheck(input:String) -> Bool {
        let pattern = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$!%*#?&])[A-Za-z[0-9]$@$!%*#?&]{7,15}"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return true
        }
        return false
    }
}

