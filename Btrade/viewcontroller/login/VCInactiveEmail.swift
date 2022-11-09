//
//  VCInactiveEmail.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/15.
//

import Foundation
import UIKit
import Alamofire

class VCInactiveEmail: VCBase, AuthTimerInterface{
    
    var result:String?
    var email:String?
    
    var AUTH:Bool = false
    @IBOutlet weak var mEmailText: UILabel!
   
    @IBOutlet weak var mAuthText: UITextField!
    @IBOutlet weak var errormsg: UILabel!
    @IBOutlet weak var mBtnAuth: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    let label1: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(result == nil || email == nil){
            prePage()
            return
        }
        mEmailText.text = email
        mAuthText.delegate = self
        mAuthText.background = UIImage(named: "text_field_inactive.png")
        mAuthText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? InactiveEmailRequest{
            let data = InactiveEmailResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("아이디를 찾을 수 없습니다.")
                return
            }
            if(code == "200"){
                comAuthEmail()
                return
            }
            
            showErrorDialog("아이디를 찾을 수 없습니다.")
        }
        if let _ = response.request as? InactiveEmailConfirmRequest{
            let data = InactiveEmailConfirmResponse(baseResponce: response)
            guard let code = data.getCode() else {
                showErrorDialog("사용할 수 없는 계정입니다.")
                return
            }
            if(code == "200"){
                nextPage()
                return
            }
            if(code == "201" || code == "202"){
                if let message = data.getMessage() {
                    showErrorDialog(message)
                    return
                }
            }
            
            showErrorDialog("사용할 수 없는 계정입니다")
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    var timer:AuthTimer?
    func initTimer(){
        timer = AuthTimer(1000*60*10, self, label1)
        timer?.start()
    }
    
    func comAuthEmail(){
        label1.widthAnchor.constraint(equalToConstant: 80).isActive = true
        stackView.addArrangedSubview(label1)
        mBtnAuth.layer.isHidden = true;
        initTimer()
        return
    }
    
    @IBAction func clickedAuth(_ sender: Any) {
        if AUTH {return}
        AUTH = true
        let request = InactiveEmailRequest()
        request.email = email
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    @IBAction func clickedNext(_ sender: Any) {
        if !AUTH {return}
        if authLengthCheck(input: mAuthText.text!) {
            let request = InactiveEmailConfirmRequest()
            request.mb_id = email
            request.token = mAuthText.text!
            ApiFactory(apiResult: self, request: request).newThread()
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        prePage()
    }
    
    
    
    func nextPage(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "inactivechangepwvc") as? VCInactiveChangePW
        pushVC?.result = result
        self.navigationController?.pushViewController(pushVC!, animated: true)
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

extension VCInactiveEmail: UITextFieldDelegate {
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == mAuthText){
            let scale = 6
            if mAuthText.text?.count ?? 0 > scale{
                mAuthText.text = (mAuthText.text?.substring(from: 0, to: scale) ?? "")
            }
            
            if(authLengthCheck(input:(mAuthText.text!))){
                errormsg.text = ""
            }else{
                errormsg.text = "인증번호 6자리를 입력하세요."
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
        if(input.count >= 6){return true}
        return false
    }
    
}
