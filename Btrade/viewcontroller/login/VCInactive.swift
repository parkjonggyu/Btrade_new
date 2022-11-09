//
//  VCInactive.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/15.
//

import Foundation
import UIKit
import Alamofire

class VCInactive: VCBase{
    @IBOutlet weak var mEditId: UITextField!
    @IBOutlet weak var errormsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mEditId.delegate = self
        mEditId.background = UIImage(named: "text_field_inactive.png")
        mEditId.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @IBAction func goNext(_ sender: Any) {
        if(!emailCheck(input:mEditId.text!)){
            return
        }
        let email:String = mEditId.text!
        let request:FindPasswordRequest = FindPasswordRequest()
        request.mb_id = email
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    func nextFind(){
        let email:String = mEditId.text!
        let request = InactiveRequest()
        request.mb_id = email
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? FindPasswordRequest{
            let data = FindPasswordResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("아이디를 찾을 수 없습니다.")
                return
            }
            if(code == "200"){
                showErrorDialog("휴면 계정이 아닙니다.")
                return
            }
            
            if(code == "9999"){
                showErrorDialog("아이디(이메일)을 찾을 수 없습니다.")
                return
            }
            
            if(code == "9000"){
                nextFind()
                return
            }
            showErrorDialog("아이디를 찾을 수 없습니다.")
        }
        
        if let _ = response.request as? InactiveRequest{
            let data = InactiveResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("아이디를 찾을 수 없습니다.")
                return
            }
            if(code == "200"){
                nextPage(response:data)
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
    
    func nextPage(response:InactiveResponse){
        if let result = response.getResult(){
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "inactiveemailvc") as? VCInactiveEmail
            
            pushVC?.result = result.toBase64()
            pushVC?.email = mEditId.text!
            self.navigationController?.pushViewController(pushVC!, animated: true)
            return
        }
        showErrorDialog("아이디를 찾을 수 없습니다.")
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        prePage()
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

extension VCInactive: UITextFieldDelegate {
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == mEditId){
            let scale = 40
            if mEditId.text?.count ?? 0 > scale{
                mEditId.text = (mEditId.text?.substring(from: 0, to: scale) ?? "")
            }
            
            if(emailCheck(input:(mEditId.text!))){
                errormsg.text = ""
            }else{
                errormsg.text = "아이디(이메일) 형식이 올바르지 않습니다."
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
    
    fileprivate func emailCheck(input:String) -> Bool {
        let pattern = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$"
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
