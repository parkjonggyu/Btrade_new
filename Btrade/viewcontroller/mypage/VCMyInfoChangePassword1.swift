//
//  VCMyInfoChangePassword1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/21.
//

import Foundation
import Alamofire

class VCMyInfoChangePassword1: VCBase {
    
    
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var passwdText: UITextField!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwdText.delegate = self
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        errorText.text = "";
        
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    @IBAction func onClicked(_ sender: Any) {
        if let error = checkInput1(input:(passwdText.text!)){
            errorText.text = error
            nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
            return
        }
        errorText.text = ""
        
        let request = MypageCheckPasswordRequest()
        request.prev_passwd = passwdText.text!.toBase64()
        ApiFactory(apiResult: self, request: request).newThread()
        
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
        if let _ = response.request as? MypageCheckPasswordRequest{
            let data = MypageCheckPasswordResponse(baseResponce: response)
            if let result = data.getStatus() {
                if(result == "success"){
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "myinfochangepassword2vc") as? VCMyInfoChangePassword2 else {
                        return
                    }
                    vc.prePasswd = passwdText.text!
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                    return;
                }
            }
                
            self.showErrorDialog("비밀번호가 올바르지 않습니다.")
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
}

extension VCMyInfoChangePassword1: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == passwdText){
            print(" : " + string)
            if let error = checkInput1(input:(textField.text! + string)){
                errorText.text = error
                nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
                return true;
            }
            errorText.text = ""
            nextBtn.setBackgroundImage(UIImage(named: "btn_blue_inactive"), for: .normal)
            if((textField.text! + string).count > 15 && string.count > 0){ return false }
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
