//
//  VCNickNameChange.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/30.
//

import Foundation
import Alamofire
import UIKit

class VCNickNameChange: VCBase {
    var vcMyInfo:VCMyInfo?
    var delegate:((String) -> Void)?
    
    @IBOutlet weak var nickNameText: UITextField!
    @IBOutlet weak var backBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameText.delegate = self
        nickNameText.background = UIImage(named: "text_field_inactive.png")
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        
        if let nick = appInfo.getMemberInfo()?.nick_name{
            nickNameText.text = nick
        }
        
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    @IBAction func onClicked(_ sender: Any) {
        if nickNameText.text!.count < 4{
            showErrorDialog("닉네임을 4자리 이상 입력해 주세요.")
            return
        }
        if let nick = appInfo.getMemberInfo()?.nick_name{
            if(nick == nickNameText.text!){
                stop()
                return
            }
        }
        
        
        let request = NicknameChangeRequest()
        request.nickname = nickNameText.text!
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? NicknameChangeRequest{
            let data = NicknameChangeResponse(baseResponce: response)
            if let result = data.getState() {
                if result == "OK"{
                    if let yn = appInfo.getMemberInfo()?.certify_nick_name{
                        if yn == "N"{
                            completionPopup("닉네임을 등록이 완료 되었습니다.")
                        }else{
                            completionPopup("닉네임을 변경이 완료 되었습니다.")
                        }
                    }
                }else{
                    showErrorDialog("닉네임을 변경하지 못했습니다.")
                }
            }
        }
        
    }
    
    fileprivate func completionPopup(_ msg:String){
        appInfo.getMemberInfo()?.certify_nick_name = "Y"
        appInfo.getMemberInfo()?.nick_name = nickNameText.text
        DialogUtils().makeDialog(
            uiVC: self,
            title: "알림",
            message: msg,
            BtradeAlertAction(title: "확인", style: .default) { (action) in
                if let d = self.delegate{
                    d(self.nickNameText.text!)
                    self.stop()
                }
            })
    }
    
    override func onError(e: AFError, method: String) {
        
    }
}

extension VCNickNameChange: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textField = nickNameText{
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if isBackSpace == -92 {
                    return true
                }
            }
            guard textField.text!.count < 16 else { return false }
            
            if(checkInput1(input:(string)) != nil){
                return false
            }
        }
        return true
    }
    
    
    fileprivate func checkInput1(input:String) -> String? {
        if(input == ""){return ""}
        let pattern = "^[_A-Za-z|0-9|가-힣|ㄱ-ㅎ|ㅏ-ㅣ]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return nil
        }
        return ""
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


