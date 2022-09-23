//
//  VCKyc2_1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/26.
//

import Alamofire
import UIKit

class VCKyc2_1: VCBase, CameraResult {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(mKyc == nil){
            stop()
            return
        }
        
        identy2Edit.delegate = self
        driveNumEdit.delegate = self
        driveCodeEdit.delegate = self
        
        identy1Edit.isUserInteractionEnabled = false
        identy3Edit.isUserInteractionEnabled = false
        identy1Edit.text = mKyc?["yyyymmdd"] as? String
        identy3Edit.text = mKyc?["yyyymmdd"] as? String

        nameText.text = mKyc?["krName"] as? String
        nameText.isUserInteractionEnabled = false
        identityLayout.layer.isHidden = true
        driverLayout.layer.isHidden = true
        itentityBtn.isUserInteractionEnabled = true
        itentityBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCamera)))
        
        createDatePickerView()
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

    @objc
    func goToCamera(sender:UITapGestureRecognizer){
        if(sender.view == itentityBtn){
            if let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kyc2cameravc") as? VCKyc2Camera{
                pushVC.delegate = self
                self.navigationController?.pushViewController(pushVC, animated: true)
            }
        }
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
                mKyc?["identity1"] = identy1Edit.text!
                mKyc?["identity2"] = identy2Edit.text!
                mKyc?["issue_date"] = issueEdit.text!
            }else if(type == "99"){
                mKyc?["identity1"] = identy3Edit.text!
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
                if(identy1Edit.text == nil || identy1Edit.text!.count != 6){
                    return "주민번호를 확인해 주세요"
                }
                if(identy2Edit.text == nil || identy2Edit.text!.count != 7){
                    return "주민번호를 확인해 주세요"
                }
                if(issueEdit.text == nil || issueEdit.text! == ""){
                    return "발급일자를 확인해 주세요"
                }
                return nil
            }else if type == "99" {
                if(identy3Edit.text == nil || identy3Edit.text!.count != 6){
                    return "주민번호를 확인해 주세요"
                }
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
    
    func result(_ data : Data?){
        if let image = data{
            
            let request = Kyc2_1UploadRequest()
            request.idUploadfile = image
            ApiFactory(apiResult: self, request: request).newThread()
        }else{
            self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요.")
        }
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
        if let _ = response.request as? Kyc2_1UploadRequest{
            authImage = false;
            let data = Kyc2_1UploadResponse(baseResponce: response)
            DispatchQueue.main.async{
                guard let message = data.getMessage() , let _ = self.mKyc else {
                    self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                    return
                }
                if message == "SUCCESS"{
                    if let rnm_no_div = data.getRnm_no_div(){
                        let index = 16
                        self.mKyc?["rnm_no_div"] = rnm_no_div
                        self.mKyc?["photo1"] = data.getFilePath()
                        self.mKyc?["requestId"] = data.getRequestId()
                        self.mKyc?["identity1"] = data.getPersonalNum_front()
                        self.mKyc?["identity2"] = data.getPersonalNum_back()
                        
                        if self.mKyc?["photo1"] == nil || self.mKyc?["requestId"] == nil || self.mKyc?["identity1"] == nil || self.mKyc?["identity2"] == nil {
                            self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                            return
                        }
                        self.authImage = true;
                        self.mKyc?["rnm_no_div"] = rnm_no_div
                        
                        
                        self.identityLayout.layer.isHidden = false
                        self.driverLayout.layer.isHidden = false
                        
                        if let url = self.mKyc?["photo1"] as? String{
                            self.itentityBtn.imageFromUrl(urlString: url);
                        }
                        if(rnm_no_div == "01"){
                            self.allStack.insertArrangedSubview(self.identityLayout, at: index)
                            self.allStack.insertArrangedSubview(self.driverLayout, at: index)
                            self.driverLayout.layer.isHidden = true
                            
                            self.identy1Edit.text = self.mKyc?["identity1"] as? String
                            self.identy2Edit.text = self.mKyc?["identity2"] as? String
                           
                            if let year:String = data.getIssueDate_year(),let mon:String = data.getIssueDate_month() ,let day:String = data.getIssueDate_day(){
                                self.setIssueEdit(year, mon, day)
                                self.mKyc?["issue_date"] = self.issueEdit.text!
                            }
                            
                            
                        }else if(rnm_no_div == "99"){
                            self.allStack.insertArrangedSubview(self.identityLayout, at: index)
                            self.allStack.insertArrangedSubview(self.driverLayout, at: index)
                            self.identityLayout.layer.isHidden = true
                            
                            self.mKyc?["issue_date"] = data.getNum()
                            self.mKyc?["drivecode"] = data.getCode()
                            
                            self.identy3Edit.text = self.mKyc?["identity1"] as? String
                            self.driveNumEdit.text = self.mKyc?["issue_date"] as? String
                            self.driveCodeEdit.text = self.mKyc?["drivecode"] as? String
                        }else{
                            self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                            return
                        }
                        return
                    }
                }
                
                self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요.")
            }
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
}


extension VCKyc2_1: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "juminfirst" || id == "juminfirst2"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 6 else { return false }
            }
            if(id == "juminlast"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 7 else { return false }
            }
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
}

protocol CameraResult:AnyObject{
    func result(_: Data?)
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
