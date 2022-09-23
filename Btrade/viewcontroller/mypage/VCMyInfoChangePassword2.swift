//
//  VCMyInfoChangePassword1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/21.
//

import Foundation
import Alamofire

class VCMyInfoChangePassword2: VCBase {
    
    var prePasswd:String?
    
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var passwdText2: UITextField!
    @IBOutlet weak var errorText2: UILabel!
    @IBOutlet weak var passwdText: UITextField!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwdText.delegate = self
        passwdText2.delegate = self
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        errorText.text = "";
        
        
        guard let _ = prePasswd else {
            stop()
            return
        }
        
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func onClicked(_ sender: Any) {
        if let error = checkInput1(input:(passwdText.text!)){
            errorText.text = error
            nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
            return
        }
        errorText.text = ""
        
        if(passwdText.text! != passwdText2.text!){
            errorText2.text = "비밀번호가 다릅니다."
            nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
            return
        }
        
        errorText2.text = ""
        
        if(prePasswd! == passwdText.text!){
            showErrorDialog("현재 비밀번호와 동일한 비밀번호는 사용할 수 없습니다.")
            return
        }
        
        let request = UpdatePasswordRequest()
        request.prev_passwd = prePasswd!.toBase64()
        request.passwd = passwdText.text!.toBase64()
        ApiFactory(apiResult: self, request: request).netThread()
        
    }
    
    fileprivate func checkInput2(input:String) -> String? {
        if(passwdText.text! != passwdText2.text!){
            return "비밀번호가 다릅니다."
        }
        return nil
    }
    
    fileprivate func checkInput1(input:String) -> String? {
        if(input == ""){return "비밀번호를 입력해 주세요"}
        let pattern = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$!%*#?&])[A-Za-z[0-9]$@$!%*#?&]{7,15}"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return nil
        }
        return "영문 대/소문자+숫자+특수문자+8자 이상."
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? UpdatePasswordRequest{
            let data = UpdatePasswordResponse(baseResponce: response)
            if let result = data.getMsg() {
                showErrorDialog(result)
                return
            }
            
            DialogUtils().makeDialog(
            uiVC: self,
            title: "비밀번호 변경",
            message:"비밀번호 변경이 완료되었습니다. 변경된 비밀번호로 재로그인해 주세요.",
            UIAlertAction(title: "확인", style: .default) { (action) in
                self.appInfo.deleteCookie()
                if let vc = UIApplication.shared.keyWindow?.rootViewController as? VCMain{
                    vc.loadLogin = true
                }
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true)
            })
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
}

extension VCMyInfoChangePassword2: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == passwdText){
            if((textField.text! + string).count > 15 && string.count > 0){ return false }
            
            if let error = checkInput1(input:(textField.text! + string)){
                errorText.text = error
                nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
                return true;
            }
            
            errorText.text = ""
            
            if let error = checkInput2(input: passwdText2.text!){
                errorText2.text = error
                nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
                return true
            }
            
            
            nextBtn.setBackgroundImage(UIImage(named: "btn_blue_inactive"), for: .normal)
            
        }else if(textField == passwdText2){
            if((textField.text! + string).count > 15 && string.count > 0){ return false }
            
            if let error = checkInput1(input:(passwdText.text!)){
                errorText.text = error
                nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
                return true
            }
            
            if(passwdText.text! != passwdText2.text! + string){
                errorText2.text = "비밀번호가 다릅니다."
                nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
                return true
            }
            errorText2.text = ""
            nextBtn.setBackgroundImage(UIImage(named: "btn_blue_inactive"), for: .normal)
            
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
