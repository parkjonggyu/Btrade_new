//
//  VCInactiveChangePW.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/18.
//

import Foundation
import UIKit
import Alamofire

class VCInactiveChangePW: VCBase{
    
    var result:String?
    
    @IBOutlet weak var mEditPW: UITextField!
    @IBOutlet weak var mEditPWCF: UITextField!
    @IBOutlet weak var errormsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(result == nil){
            prePage()
            return
        }
        
        mEditPW.delegate = self
        mEditPWCF.delegate = self
    }
    
    @IBAction func clickedNext(_ sender: Any) {
        if(!passwordCheck(input:mEditPW.text!)){
           errormsg.text = "패스워드 형식이 올바르지 않습니다.(영문, 숫자, 특수문자 조합)"
            return
        }
        
        if(!cfpwCheck()){
            errormsg.text = "패스워드 형식이 올바르지 않습니다.(영문, 숫자, 특수문자 조합)"
            return
        }
        
        let request = InactiveChangePwRequest()
        request.passwd = mEditPW.text?.toBase64()
        request.check_passwd = mEditPWCF.text?.toBase64()
        request.mb_idx = result
        ApiFactory(apiResult: self, request: request).netThread()
        
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? InactiveChangePwRequest{
            let data = InactiveChangePwResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("아이디를 찾을 수 없습니다.")
                return
            }
            if(code == "200"){
                nextPage()
                return
            }
            if let msg = data.getMsg(){
                showErrorDialog(msg)
                return
            }
            showErrorDialog("아이디를 찾을 수 없습니다.")
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    func cfpwCheck() -> Bool{
        let pw1 = mEditPW.text!
        let pw2 = mEditPWCF.text!
        if(pw1 == pw2){return true}
        return false
    }
    
    @IBAction func goBack(_ sender: Any) {
        prePage()
    }
    
    func nextPage(){
        showErrorDialog("정상처리 되었습니다. 로그인 페이지로 이동합니다"){ action in
            self.prePage()
        }
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

extension VCInactiveChangePW: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "signuppw"){
                if(passwordCheck(input:(textField.text! + string))){
                    errormsg.text = ""
                }else{
                    errormsg.text = "패스워드 형식이 올바르지 않습니다.(영문, 숫자, 특수문자 조합)"
                }
                if((textField.text! + string).count > 15 && string.count > 0){ return false }
            }else if(id == "signuppwcf"){
                if(self.mEditPW.text! == (textField.text! + string)){
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
    
    func passwordCheck(input:String) -> Bool {
        let pattern = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$!%*#?&])[A-Za-z[0-9]$@$!%*#?&]{7,15}"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return true
        }
        return false
    }
}
extension String {
    fileprivate func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    fileprivate func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
