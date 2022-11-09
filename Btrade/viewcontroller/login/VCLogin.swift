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
    @IBOutlet weak var mEditIdLayout: UIView!
    @IBOutlet weak var mEditPwLayout: UIView!
    
    @IBOutlet weak var errormsgId: UILabel!
    @IBOutlet weak var errormsgPw: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mEditId.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        mEditPw.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        mEditId.delegate = self
        mEditPw.delegate = self
        mEditId.background = UIImage(named: "text_field_inactive.png")
        mEditPw.background = UIImage(named: "text_field_inactive.png")

    }
    
    @IBAction func loginStart(_ sender: Any) {
        let id = mEditId.text!
        let pw = mEditPw.text!
        let errordata1 = errormsgId.text!
        let errordata2 = errormsgPw.text!
        if(id.count == 0 || pw.count == 0 || errordata1.count > 0 || errordata2.count > 0){return}
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
        BtradeAlertAction(title: "고객확인제도 인증", style: .default) { (action) in
            self.appInfo.isKycVisible = true
            self.goMain()
        },
        BtradeAlertAction(title: "다음에 하기", style: .destructive) { (action) in
            self.goMain()
        })
    }
    
    func goOTPVC(response:SignInResponse){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "loginotpvc") as! VCLoginOTP
        let id = mEditId.text!
        let pw = mEditPw.text!
        let errordata1 = errormsgId.text!
        let errordata2 = errormsgPw.text!
        if(id.count == 0 || pw.count == 0 || errordata1.count > 0 || errordata2.count > 0){return}
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
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == mEditId){
            if(emailCheck(input:(mEditId.text!))){
                errormsgId.text = ""
            }else{
                errormsgId.text = "아이디(이메일) 형식이 올바르지 않습니다."
            }
            let scale = 40
            if mEditId.text?.count ?? 0 > scale{
                mEditId.text = (mEditId.text?.substring(from: 0, to: scale) ?? "")
            }
            
        }else if(sender == mEditPw){
            if(passwordCheck(input:(mEditPw.text!))){
                errormsgPw.text = ""
            }else{
                errormsgPw.text = "패스워드 형식이 올바르지 않습니다."
            }
            let scale = 20
            if mEditPw.text?.count ?? 0 > scale{
                mEditPw.text = (mEditPw.text?.substring(from: 0, to: scale) ?? "")
            }
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mEditId{
            mEditId.background = UIImage(named: "text_field_active.png")
            //mEditIdLayout.backgroundColor = UIColor(named: "CTextActive")
        }else{
            mEditPw.background = UIImage(named: "text_field_active.png")
           //mEditPwLayout.backgroundColor = UIColor(named: "CTextActive")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mEditId{
            mEditId.background = UIImage(named: "text_field_inactive.png")
            //mEditIdLayout.backgroundColor = UIColor(named: "CTextDeActive")
        }else{
            mEditPw.background = UIImage(named: "text_field_inactive.png")
            //mEditPwLayout.backgroundColor = UIColor(named: "CTextDeActive")
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
