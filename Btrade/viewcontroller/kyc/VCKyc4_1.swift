//
//  VCKyc4_1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/03.
//


import Alamofire
import UIKit

class VCKyc4_1: VCBase, AuthTimerInterface{
   
    
    var mKyc:Dictionary<String, Any>!
    
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var authEdit: UITextField!
    @IBOutlet weak var mTimerText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(mKyc == nil){
            stop()
            return
        }
        
        authEdit.delegate = self
        bankName.text = (mKyc["bankName"] as! String) + " " + (mKyc["accountNum"] as! String)
        initTimer()
    }
    
    var timer:AuthTimer?
    func initTimer(){
        timer = AuthTimer(60000*5, self, mTimerText)
        timer?.start()
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        stop()
    }
    
    fileprivate func stop(){
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func nextStep(_ sender: Any) {
        guard let _ = authEdit.text else{
            showErrorDialog("인증번호를 정확히 입력하세요.")
            return
        }
        if authEdit.text!.count != 4 {
            showErrorDialog("인증번호를 정확히 입력하세요.")
            return
        }
        
        let request = KycAccountAuthRequest()
        request.auth_code = authEdit.text!
        request.verify_tr_dt = mKyc["verify_tr_dt"] as? String
        request.verify_tr_no = mKyc["verify_tr_no"] as? String
        request.user_nm = mKyc["krName"] as? String
        request.fnni_cd = mKyc["bankCode"] as? String
        request.bank_name = mKyc["bankName"] as? String
        request.acct_no = mKyc["accountNum"] as? String
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? KycAccountAuthRequest{
            let data = KycAccountAuthResponse(baseResponce: response)
            guard let result = data.getResult_cd() else {
                self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                return
            }
            
            if (result == "y"){
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kyccomvc") as? VCKycCom
                self.navigationController?.pushViewController(pushVC!, animated: true)
                return
            }
            
            guard let msg = data.getResult_Msg() else {
                self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                return
            }
            
            self.showErrorDialog(msg)
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    
    func endTimer() {
        showErrorDialog("인증시간이 지났습니다. 다시 시도하세요."){_ in
            self.stop()
        }
    }
}

extension VCKyc4_1: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "accountnum"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 25 else { return false }
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


