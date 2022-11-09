//
//  VCLoginOTPRemove.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/11.
//

import Foundation
import UIKit

class VCLoginOTPRemove: VCBase {

    @IBOutlet weak var mEditOTP: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mEditOTP.delegate = self
        mEditOTP.background = UIImage(named: "text_field_inactive.png")
        mEditOTP.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goOTPRemove(_ sender: UIButton) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "loginotpvc")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    @IBAction func startLogIn(_ sender: UIButton) {
        if mEditOTP.text?.count != 6 {return}
        let request = SignInOTPRequest()
        request.otp_number = mEditOTP.text!
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? SignInOTPRequest{
            let data = SignInResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("로그인 오류, 관리자에게 문의하세요.")
                return
            }
            
            if code == "200"{
                goMain()
                return
            }
            if code == "207"{
                goMainWithKYCPopup()
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
            showErrorDialog("OTP 번호가 잘못되었습니다.")
        }
    }
    
    func goMain(){
        self.navigationController?.dismiss(animated: true)
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
}


extension VCLoginOTPRemove: UITextFieldDelegate {
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == mEditOTP){
            let scale = 44
            if mEditOTP.text?.count ?? 0 > scale{
                mEditOTP.text = (mEditOTP.text?.substring(from: 0, to: scale) ?? "")
            }
            
        }
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
