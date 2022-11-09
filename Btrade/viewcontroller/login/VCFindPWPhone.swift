//
//  VCFindPWPhone.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/14.
//

import Foundation
import UIKit
import Alamofire

class VCFindPWPhone: VCBase, AuthTimerInterface{
    
    var result:String?
    var email:String?
    var IDX:String?
    var AUTH:Bool = false
    
    let label1: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var errormsg: UILabel!
    @IBOutlet weak var mAuthEdit: UITextField!
    
    @IBOutlet weak var mAuthBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(result == nil || email == nil){
            prePage()
            return
        }
        mAuthEdit.delegate = self
        mAuthEdit.background = UIImage(named: "text_field_inactive.png")
        mAuthEdit.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func onAuthClicked(_ sender: UIButton) {
        if AUTH {return}
        AUTH = true
        let request = InactivePhoneRequest()
        request.mb_idx = result
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    @IBAction func onOkClicked(_ sender: Any) {
        if(!AUTH){
            errormsg.text = "인증요청을 진행해 주세요."
            return
        }
        if(!authLengthCheck(input:mAuthEdit.text!)){
            errormsg.text = "인증코드 4자리를 입력하세요."
            return
        }
        
        let request = InactivePhoneConfirmRequest()
        request.mb_idx = result
        request.code = mAuthEdit.text!
        request.idx = IDX
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? InactivePhoneConfirmRequest{
            let data = InactivePhoneConfirmResponse(baseResponce: response)
            if let state = data.getState(){
                if(state == "OK"){
                    findPWSendEmail(response:data)
                    return
                }
            }
            
            if let msg = data.getMsg(){
                showErrorDialog(msg)
                return
            }
            showErrorDialog("사용할 수 없는 계정입니다.")
        }
        
        if let _ = response.request as? InactivePhoneRequest{
            let data = InactivePhoneResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("사용할 수 없는 계정입니다."){ action in
                    self.prePage()
                }
                return
            }
            if(code == "200"){
                okAuth(response:data)
                return
            }
            showErrorDialog("사용할 수 없는 계정입니다.")
        }
        
        if let _ = response.request as? FindPWSendEmailRequest{
            let data = FindPWSendEmailResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("사용할 수 없는 계정입니다.")
                return
            }
            if(code == "200"){
                nextPage()
                return
            }
            showErrorDialog("사용할 수 없는 계정입니다.")
        }
        
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    func findPWSendEmail(response:InactivePhoneConfirmResponse){
        if let _ = response.getResult(){
            let request:FindPWSendEmailRequest = FindPWSendEmailRequest()
            request.mb_idx = result
            request.find_type = "2"
            ApiFactory(apiResult: self, request: request).newThread()
        }
        showErrorDialog("사용할 수 없는 계정입니다.")
    }
    
    func okAuth(response:InactivePhoneResponse){
        if let idx = response.getResult(){
            IDX = idx.toBase64()
            label1.widthAnchor.constraint(equalToConstant: 80).isActive = true
            stackView.addArrangedSubview(label1)
            mAuthBtn.layer.isHidden = true;
            initTimer()
            return
        }
        showErrorDialog("사용할 수 없는 계정입니다."){ action in
            self.prePage()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.stop()
    }
    
    var timer:AuthTimer?
    func initTimer(){
        timer = AuthTimer(1000*60*2, self, label1)
        timer?.start()
    }
    
    func nextPage(){
        DialogUtils().makeDialog(
            uiVC: self,
            title: "임시 비밀번호",
            message:"임시 비밀번호가 이메일로 발송 되었습니다",
            BtradeAlertAction(title: "확인", style: .default) { (action) in
                self.prePage()
            })
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
    
    func endTimer() {
        DialogUtils().makeDialog(
            uiVC: self,
            title: "알림",
            message:"인증 시간이 자났습니다. 다시 시도하세요.",
            BtradeAlertAction(title: "확인", style: .default) { (action) in
                self.prePage()
            })
    }
}


extension VCFindPWPhone: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if !AUTH {
            errormsg.text = "인증요청을 진행해 주세요."
            return;
        }
        
        if(sender == mAuthEdit){
            let scale = 4
            if mAuthEdit.text?.count ?? 0 > scale{
                mAuthEdit.text = (mAuthEdit.text?.substring(from: 0, to: scale) ?? "")
            }
            if(authLengthCheck(input:(mAuthEdit.text!))){
                errormsg.text = ""
            }else{
                errormsg.text = "인증번호 4자리를 입력하세요."
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
    
    func authLengthCheck(input:String) -> Bool {
        if(input.count >= 4){return true}
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
