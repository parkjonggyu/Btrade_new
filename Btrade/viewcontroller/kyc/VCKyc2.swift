//
//  VCKyc2.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/26.
//

import Foundation
import UIKit

class VCKyc2: VCBase, WebResult {
    
    
    var name:String?
    var phoneNum:String?
    var birthday:String?
    var birthdayAll:String?
    
    var mKyc:Dictionary<String, Any> = Dictionary<String, Any>()
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var enLastNameEdit: UITextField!
    @IBOutlet weak var enFirstNameEdit: UITextField!
    @IBOutlet weak var addr1Edit: UITextField!
    @IBOutlet weak var addr2Edit: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var addrBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(name == nil || phoneNum == nil){
            stop()
            return
        }
        
        nameText.text = name
        nameText.isUserInteractionEnabled = false
        addr1Edit.isUserInteractionEnabled = false
        enLastNameEdit.delegate = self
        enFirstNameEdit.delegate = self
        addr2Edit.delegate = self
        enLastNameEdit.background = UIImage(named: "text_field_inactive.png")
        enFirstNameEdit.background = UIImage(named: "text_field_inactive.png")
        addr2Edit.background = UIImage(named: "text_field_inactive.png")
        
        enFirstNameEdit.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        enLastNameEdit.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        addrBtn.isUserInteractionEnabled = true
        addrBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addrCheckView1)))
        
    }
    
    @objc func textFieldDidChange(_ sender: UITextField?) {
        sender?.text = sender?.text!.uppercased()
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        stop()
    }
    
    fileprivate func stop(){
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc
    func addrCheckView1(sender:UITapGestureRecognizer){
        if(sender.view == addrBtn){
            openAddrPopup()
        }
    }
    
    fileprivate func openAddrPopup() {
        let sb = UIStoryboard.init(name:"Webview", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "webvc") as? VCWeb else {
            return
        }
        vc.page = BuildConfig.SERVER_URL + "m/mypage/kycAuth/addr.do"
        vc.smsDelegate = self
        vc.titleString = "비트레이드 - 주소검색"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
    func result(_ data: Dictionary<String, Any>) {
        mKyc = data
        setTextInView()
    }
    
    func setTextInView(){
        if mKyc["roadAddress"] != nil {
            addr1Edit.text = mKyc["roadAddress"] as! String + " " + (mKyc["buildingName"] as? String ?? "")
        }else if mKyc["autoJibunAddress"] != nil{
            addr1Edit.text = mKyc["autoJibunAddress"] as? String
        }else if mKyc["jibunAddress"] != nil{
            addr1Edit.text = mKyc["jibunAddress"] as? String
        }
    }
    
    
    @IBAction func nextBtnStep(_ sender: Any) {
        let error = checkError()
        if let msg = error{
            showErrorDialog(msg)
            return
        }
        nextStep()
    }
    
    fileprivate func checkError() -> String?{
        if(addr1Edit.text == nil || addr1Edit.text! == ""){
            return "주소를 입력해 주세요"
        }
        if(addr2Edit.text == nil || addr2Edit.text! == ""){
            return "나머지 주소를 입력해 주세요"
        }
        if(enLastNameEdit.text == nil || enLastNameEdit.text! == ""){
            return "영문 성을 입력해 주세요"
        }
        if(enFirstNameEdit.text == nil || enFirstNameEdit.text! == ""){
            return "영문 이름을 입력해 주세요"
        }
        
        return nil
    }
    
    fileprivate func nextStep() {
        mKyc["krName"] = name
        mKyc["phone_no"] = phoneNum
        mKyc["yyyymmdd"] = birthday
        mKyc["yyyymmddAll"] = birthdayAll
        mKyc["enFirstName"] = enFirstNameEdit.text!
        mKyc["enLastName"] = enLastNameEdit.text!
        mKyc["detailAddress"] = addr2Edit.text!
        
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "VCKyc2_2") as? VCKyc2_2
        pushVC?.mKyc = mKyc
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
}


extension VCKyc2: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "lastname" || id == "firstname"){
                
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                
                guard textField.text!.count < 30 else { return false }
                
                if(!nameCheck(input:(string))){
                    return false
                }
                
            }else if(id == "detailaddr"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                
                guard textField.text!.count < 50 else { return false }
                
                if(checkInput1(input:(string)) != nil){
                    return false
                }
            }
        }
        return true
    }
    
    
    fileprivate func checkInput1(input:String) -> String? {
        if(input == ""){return ""}
        let pattern = "^[_A-Za-z|0-9|가-힣|ㄱ-ㅎ|ㅏ-ㅣ|-| ]+$"
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
    
    fileprivate func nameCheck(input:String) -> Bool {
        let pattern = "^[_A-Za-z]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return true
        }
        return false
    }
    
}
