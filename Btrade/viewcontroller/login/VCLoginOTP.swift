//
//  VCLoginOTP.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/11.
//

import UIKit

class VCLoginOTP: VCBase {

    @IBOutlet weak var mEditOTP: UITextField!
    @IBOutlet weak var mEditOTPLayout: UIView!
    
    var mId : String = ""
    var mPw : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        mEditOTP.delegate = self
        mEditOTP.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        mEditOTP.background = UIImage(named: "text_field_inactive.png")
    }
    
    
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goOTPRemove(_ sender: UIButton) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "loginotpremovevc")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    @IBAction func startLogIn(_ sender: UIButton) {
        if mEditOTP.text?.count != 6 {return}
        let request = SignInOTPRequest()
        request.login_id = mId
        request.login_password = mPw
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
}


extension VCLoginOTP: UITextFieldDelegate {
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == mEditOTP){
            let scale = 6
            if mEditOTP.text?.count ?? 0 > scale{
                mEditOTP.text = (mEditOTP.text?.substring(from: 0, to: scale) ?? "")
            }
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mEditOTP.background = UIImage(named: "text_field_active.png")
        //mEditOTPLayout.backgroundColor = UIColor(named: "CTextActive")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            mEditOTP.background = UIImage(named: "text_field_inactive.png")
            //mEditOTPLayout.backgroundColor = UIColor(named: "CTextDeActive")
    }
}
