//
//  VCKyc2_1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/26.
//

import Alamofire
import UIKit

class VCKyc2_1: VCBase {
    @IBOutlet weak var imageLayout: UIView!
    @IBOutlet weak var itentityBtn: UIImageView!
    @IBOutlet weak var issueEdit: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var identityLayout: UIStackView!
    @IBOutlet weak var driverLayout: UIStackView!
    
    @IBOutlet weak var identy1Edit: UITextField!
    @IBOutlet weak var identy2Edit: UITextField!
    @IBOutlet weak var identy3Edit: UITextField!
    @IBOutlet weak var driveNumEdit: UITextField!
    @IBOutlet weak var driveCodeEdit: UITextField!
    
    @IBOutlet weak var allStack: UIStackView!
    
    let datePicker = UIDatePicker()
    var mKyc:Dictionary<String, Any>?
    var authImage = false
    var keyHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(mKyc == nil){
            stop()
            return
        }
        
        initLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        createDatePickerView()
    }
    
    fileprivate func initLayout(){
        identy2Edit.delegate = self
        driveNumEdit.delegate = self
        driveCodeEdit.delegate = self
        identy2Edit.background = UIImage(named: "text_field_inactive.png")
        driveNumEdit.background = UIImage(named: "text_field_inactive.png")
        driveCodeEdit.background = UIImage(named: "text_field_inactive.png")
        
        identy1Edit.isUserInteractionEnabled = false
        identy2Edit.isUserInteractionEnabled = false
        identy3Edit.isUserInteractionEnabled = false
        nameText.isUserInteractionEnabled = false
        
        nameText.text = mKyc?["krName"] as? String
        identy1Edit.text = mKyc?["identity1"] as? String
        identy2Edit.text = mKyc?["identity2"] as? String
        identy3Edit.text = mKyc?["identity1"] as? String
        
        if let url = self.mKyc?["photo1"] as? String{
            self.itentityBtn.imageFromUrl(urlString: url);
        }
        
        if let rnm_no_div = mKyc?["rnm_no_div"] as? String{
            if rnm_no_div == "01"{
                driverLayout.layer.isHidden = true
                issueEdit.text = self.mKyc?["issue_date"] as? String
            }else{
                identityLayout.layer.isHidden = true
                driveNumEdit.text = self.mKyc?["issue_date"] as? String
                driveCodeEdit.text = self.mKyc?["drivecode"] as? String
            }
        }
    }
    
    //날짜 처리
    func createDatePickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        issueEdit.inputAccessoryView = toolbar
        issueEdit.inputView = datePicker
    }
    
    func setIssueEdit(_ year:String,_ mon_:String,_ day_:String){
        var mon = ""
        var day = ""
        if(mon_.count == 1){mon = "0" + mon_}
        if(day_.count == 1){day = "0" + day_}
        
        issueEdit.text = year + "-" + mon + "-" + day
    }
    
    
    @objc func donePressed() {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        
        issueEdit.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    var aa = true
    @IBAction func goBack(_ sender: Any) {
        stop()
    }
    
    
    @IBAction func nexBtnStep(_ sender: Any) {
        let error = checkError()
        if let msg = error{
            showErrorDialog(msg)
            return
        }
        nextStep()
    }
    
    fileprivate func nextStep(){
        if let type = mKyc?["rnm_no_div"] as? String{
            if(type == "01"){
                mKyc?["issue_date"] = issueEdit.text!
            }else if(type == "99"){
                mKyc?["issue_date"] = driveNumEdit.text!
                mKyc?["drivecode"] = driveCodeEdit.text!
            }
            let request = Kyc2UploadRequest()
            request.setKyc2Data(mKyc)
            ApiFactory(apiResult: self, request: request).newThread()
        }
    }
    
    fileprivate func checkError() -> String?{
        if let type = mKyc?["rnm_no_div"] as? String{
            if(type == "01"){
                if(issueEdit.text == nil || issueEdit.text! == ""){
                    return "발급일자를 확인해 주세요"
                }
                return nil
            }else if type == "99" {
                if(driveNumEdit.text == nil || driveNumEdit.text!.count < 6){
                    return "운전면허번호를 확인해 주세요"
                }
                if(driveCodeEdit.text == nil || driveCodeEdit.text!.count != 6){
                    return "암호일련번호를 확인해 주세요"
                }
                return nil
            }
        }
        return "신분증을 촬영해주세요."
    }
    
    fileprivate func stop(){
        self.navigationController?.dismiss(animated: true)
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? Kyc2UploadRequest{
            let data = Kyc2UploadResponse(baseResponce: response)
            guard let result = data.getResult_cd() else {
                self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                return
            }
            
            if (result == "y"){
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kyc3vc") as? VCKyc3
                pushVC?.mKyc["krName"] = mKyc?["krName"] as? String
                self.navigationController?.pushViewController(pushVC!, animated: true)
                return
            }
            
            guard let msg = data.getResult_msg() else {
                self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                return
            }
            
            self.showErrorDialog(msg)
            
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
}


extension VCKyc2_1: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "drivenum"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 15 else { return false }
            }
            if(id == "drivecode"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 6 else { return false }
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
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        if keyHeight > 0 {return}
        
        keyHeight = keyboardHeight
        self.view.frame.size.height -= keyboardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.size.height += keyHeight
        keyHeight = 0
    }
}


extension UIImageView{
    fileprivate func imageFromUrl(urlString:String){
        let string = BuildConfig.IAMGE_URL + urlString
        print(string)
        let url = URL(string: string)
        if let data = try? Data(contentsOf: url!){
            self.translatesAutoresizingMaskIntoConstraints = false
            self.widthAnchor.constraint(equalToConstant: 200).isActive = true
            self.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.image = UIImage(data: data)
        }
    }
}
