//
//  VCLogin.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/07.
//

import UIKit
import Alamofire

class VCLogin: VCBase {

    @IBOutlet weak var mEditId: UITextField!
    @IBOutlet weak var mEditPw: UITextField!
    @IBOutlet weak var errormsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mEditId.delegate = self
        mEditPw.delegate = self
    }
    
    @IBAction func loginStart(_ sender: Any) {
        let id = mEditId.text!
        let pw = mEditPw.text!
        let errordata = errormsg.text!
        if(id.count == 0 || pw.count == 0 || errordata.count > 0){return}
        let request = SignInRequest()
        request.login_id = id
        request.login_password = pw.toBase64()
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    @IBAction func goToSignup(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "signuptermsvc")
        
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? SignInRequest{
            let data = SignInResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("로그인 오류, 관리자에게 문의하세요.")
                return
            }
            
            if code == "200"{
                goMain()
                return
            }
            if code == "202"{
                goOTPVC(response:data);
                return
            }
            if code == "207"{
                goMainWithKYCPopup()
                return
            }
            if code == "203"{
                
                return
            }
            if code == "205" || code == "206"{
                showErrorDialog("휴면계정입니다. 계정활성화를 해주세요.")
                return
            }
            if code == "999"{
                showErrorDialog("사용할 수 없는 계정입니다.")
                return
            }
            showErrorDialog("아이디 혹은 패스워드가 잘못되었습니다.")
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    func goMain(){
        UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
    }
    
    func goMainWithKYCPopup(){
        DialogUtils().makeDialog(
        uiVC: self,
        title: "고객확인제도",
        message:"고객확인 인증 절차를 완료한 후, 모든 거래서비스, 입출금 이용이 가능합니다.",
        UIAlertAction(title: "고객확인제도 인증", style: .default) { (action) in
            self.appInfo.isKycVisible = true
            self.goMain()
        },
        UIAlertAction(title: "다음에 하기", style: .destructive) { (action) in
            self.goMain()
        })
    }
    
    func goOTPVC(response:SignInResponse){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "loginotpvc") as! VCLoginOTP
        let id = mEditId.text!
        let pw = mEditPw.text!
        let errordata = errormsg.text!
        if(id.count == 0 || pw.count == 0 || errordata.count > 0){return}
        pushVC.mId = id
        pushVC.mPw = pw.toBase64()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    
    @IBAction func goInactive(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "findpwphonevc")
        
        self.navigationController?.pushViewController(pushVC!, animated: true)
        
    }
}

extension VCLogin: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "editid"){
                if(emailCheck(input:(textField.text! + string))){
                    errormsg.text = ""
                }else{
                    errormsg.text = "아이디(이메일) 형식이 올바르지 않습니다."
                }
                if((textField.text! + string).count > 40 && string.count > 0){ return false }
            }else if(id == "editpw"){
                if(passwordCheck(input:(textField.text! + string))){
                    errormsg.text = ""
                }else{
                    errormsg.text = "패스워드 형식이 올바르지 않습니다."
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
    
    fileprivate func emailCheck(input:String) -> Bool {
        let pattern = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return true
        }
        return false
    }
    
    fileprivate func passwordCheck(input:String) -> Bool {
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
