//
//  VCKyc4.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/02.
//

import Alamofire
import UIKit

class VCKyc4: VCBase{
    
    var mKyc:Dictionary<String, Any> = Dictionary<String, Any>()
    
    
    @IBOutlet weak var accountNumEdit: UITextField!
    @IBOutlet weak var bankSelect: UIView!
    @IBOutlet weak var bankEdit: UITextField!
    @IBOutlet weak var backBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountNumEdit.delegate = self
        accountNumEdit.background = UIImage(named: "text_field_inactive.png")
        bankEdit.isUserInteractionEnabled = false
        
        
        bankSelect.isUserInteractionEnabled = true
        bankSelect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
    }
    
    @objc func onClicked(sender:UITapGestureRecognizer){
        if sender.view == backBtn {
            stop()
        }else if sender.view == bankSelect {
            startDropDown()
        }
    }
    fileprivate func stop(){
        self.navigationController?.dismiss(animated: true)
    }
    
    
    @IBAction func nextStep(_ sender: Any) {
        if let error = error(){
            showErrorDialog(error)
            return
        }
        setNextStep()
    }
    
    fileprivate func error() -> String?{
        if(mKyc["krName"] == nil){
            return "에러가 발생했습니다."
        }
        if(mKyc["bankCode"] == nil || (mKyc["bankCode"] as! String).count == 0){
            return "은행을 선택해 주세요."
        }
        if(accountNumEdit.text!.count < 5){
            return "계좌번호를 정확히 입력해 주세요."
        }
        
        return nil
    }
    
    fileprivate func setNextStep(){
        let request = AccountConfirmRequest()
        request.jumin_no = ""
        request.user_nm = mKyc["krName"] as? String
        request.fnni_cd = mKyc["bankCode"] as? String
        mKyc["accountNum"] = accountNumEdit.text
        request.acct_no = accountNumEdit.text
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? AccountConfirmRequest{
            let data = AccountConfirmResponse(baseResponce: response)
            guard let result = data.getResult_cd() else {
                self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                return
            }
            
            if (result == "y"){
                mKyc["verify_tr_dt"] = data.getVerify_tr_dt()
                mKyc["verify_tr_no"] = data.getVerify_tr_no()
                
                
                
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kyc4_1vc") as? VCKyc4_1
                pushVC?.mKyc = mKyc
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
    
    func onSelect(_ item:KycVo.SMAP) {
        mKyc["bankCode"] = item.value
        mKyc["bankName"] = item.key
        bankEdit.text = item.key
    }
}



extension VCKyc4: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "accountnum"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 40 else { return false }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.background = UIImage(named: "text_field_active.png")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.background = UIImage(named: "text_field_inactive.png")
    }
    
    fileprivate func startDropDown(){
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "PopupBank") as? PopupBank else {
            return
        }
        vc.delegate = {[weak self] smap in
            self?.onSelect(smap)
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true);
    }
}

