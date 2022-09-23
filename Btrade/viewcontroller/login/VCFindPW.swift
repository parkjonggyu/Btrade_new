//
//  VCFindPW.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/14.
//

import Foundation
import UIKit
import Alamofire

class VCFindPW: VCBase{
    
    @IBOutlet weak var mEditId: UITextField!
    @IBOutlet weak var errormsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mEditId.delegate = self
    }
    
    
    
    @IBAction func goNext(_ sender: Any) {
        if(!emailCheck(input:mEditId.text!)){
            return
        }
        var email:String = mEditId.text!
        var request:FindPasswordRequest = FindPasswordRequest()
        request.mb_id = email
        ApiFactory(apiResult: self, request: request).netThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? FindPasswordRequest{
            let data = FindPasswordResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("아이디를 찾을 수 없습니다.")
                return
            }
            if(code == "200"){
                nextPage(response:data)
                return
            }
            
            if(code == "9999"){
                showErrorDialog("아이디(이메일)을 찾을 수 없습니다.")
                return
            }
            
            if(code == "9000"){
                DialogUtils().makeDialog(
                    uiVC: self,
                    title: "휴면 계정",
                    message:"현재 회원님의 계정은 휴면상태입니다.",
                    UIAlertAction(title: "휴면 해제", style: .default) { (action) in
                        self.goInactive()
                    },
                    UIAlertAction(title: "확 인", style: .destructive) { (action) in
                        self.prePage()
                    })
                return
            }
            
            
            
            showErrorDialog("아이디를 찾을 수 없습니다.")
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    func goInactive(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "inactivevc")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    func nextPage(response:FindPasswordResponse){
        if let result = response.getResult(){
            if let amlState = response.getAmlState(){
                if(amlState == "cc"){
                    nextPagePhone(result:result, email:mEditId.text!)
                }else{
                    nextPageEmail(result:result, email:mEditId.text!)
                }
                return
            }
        }
        showErrorDialog("아이디를 찾을 수 없습니다.")
    }
    
    func nextPagePhone(result:String, email:String){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "findpwphonevc") as? VCFindPWPhone
        
        pushVC?.result = result
        pushVC?.email = email
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    func nextPageEmail(result:String, email:String){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "findpwemailvc") as? VCFindPWEmail
        
        pushVC?.result = result.toBase64()
        pushVC?.email = email
        self.navigationController?.pushViewController(pushVC!, animated: true)
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

extension VCFindPW: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "editid"){
                if(emailCheck(input:(textField.text! + string))){
                    errormsg.text = ""
                }else{
                    errormsg.text = "아이디(이메일) 형식이 올바르지 않습니다."
                }
                if((textField.text! + string).count > 40 && string.count > 0){ return false }
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
