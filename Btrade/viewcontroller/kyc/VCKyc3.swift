    //
    //  VCKyc3.swift
    //  Btrade
    //
    //  Created by 블록체인컴퍼니 on 2022/08/02.
    //

import Alamofire
import UIKit

class VCKyc3: VCBase, WebResult{
    
    var mKyc:Dictionary<String, Any> = Dictionary<String, Any>()
    
    let JOBSELECT = 10, PURPOSE = 11, FUND = 12, SUBJOB = 13
    var myFund = true
    
    
    @IBOutlet weak var jobSelectBtn: UIView!
    @IBOutlet weak var jobEdit: UITextField!
    @IBOutlet weak var puposeSelectBtn: UITextField!
    @IBOutlet weak var puposeEdit: UITextField!
    @IBOutlet weak var fundSelectBtn: UITextField!
    @IBOutlet weak var fundEdit: UITextField!
    
    @IBOutlet weak var inputLayout1: UIView!
    @IBOutlet weak var inputLayout2: UIView!
    @IBOutlet weak var subNameText: UILabel!
    @IBOutlet weak var subAddrText: UILabel!
    @IBOutlet weak var subTypeText: UILabel!
    
    @IBOutlet weak var subNameEdit: UITextField!
    @IBOutlet weak var subAddr1Edit: UITextField!
    @IBOutlet weak var subAddr2Edit: UITextField!
    @IBOutlet weak var subTypeBtn: UIView!
    @IBOutlet weak var subTypeEdit: UITextField!
    
    @IBOutlet weak var addrBtn: UIImageView!
    @IBOutlet weak var yesBtn: UIImageView!
    @IBOutlet weak var yesText: UILabel!
    @IBOutlet weak var noBtn: UIImageView!
    @IBOutlet weak var noText: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    
    var subTitle1 = "직장명"
    var subTitle2 = "직장 주소"
    var subTitle3 = "직종"
    var subTitle4 = "직장 주소 검색"
    var subTitle5 = "직장명을 입력해 주세요."
    var subTitle6 = "직종을 선택해 주세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mKyc["isJobOptions"] = true
        mKyc["jobtype"] = "00"
        mKyc["jobcode"] = "00"
        mKyc["businesstype"] = "00"
        mKyc["purpose"] = "00"
        mKyc["source"] = "00"
        
        subNameEdit.delegate = self
        subAddr2Edit.delegate = self
        subNameEdit.background = UIImage(named: "text_field_inactive.png")
        subAddr2Edit.background = UIImage(named: "text_field_inactive.png")
        jobEdit.isUserInteractionEnabled = false
        subAddr1Edit.isUserInteractionEnabled = false
        puposeEdit.isUserInteractionEnabled = false
        fundEdit.isUserInteractionEnabled = false
        subTypeEdit.isUserInteractionEnabled = false
        
        inputLayout1.isHidden = true
        inputLayout2.isHidden = true
        
        subNameEdit.background = UIImage(named: "text_field_inactive.png")
        subAddr2Edit.background = UIImage(named: "text_field_inactive.png")
        
        yesBtn.isUserInteractionEnabled = true
        yesBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        yesText.isUserInteractionEnabled = true
        yesText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        noBtn.isUserInteractionEnabled = true
        noBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        noText.isUserInteractionEnabled = true
        noText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        jobSelectBtn.isUserInteractionEnabled = true
        jobSelectBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        puposeSelectBtn.isUserInteractionEnabled = true
        puposeSelectBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        fundSelectBtn.isUserInteractionEnabled = true
        fundSelectBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        addrBtn.isUserInteractionEnabled = true
        addrBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        subTypeBtn.isUserInteractionEnabled = true
        subTypeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        
    }
    
    func result(_ map: Dictionary<String, Any>) {
        for (key,value) in map{
            mKyc["job" + key] = value
        }
        setTextInView()
    }
    
    fileprivate func setTextInView(){
        if mKyc["jobroadAddress"] != nil {
            subAddr1Edit.text = mKyc["jobroadAddress"] as! String + " " + (mKyc["jobbuildingName"] as? String ?? "")
        }else if mKyc["jobautoJibunAddress"] != nil{
            subAddr1Edit.text = mKyc["ajobutoJibunAddress"] as? String
        }else if mKyc["jobjibunAddress"] != nil{
            subAddr1Edit.text = mKyc["jobjibunAddress"] as? String
        }
    }
    
    fileprivate func jobOptionVisible(){
        inputLayout1.isHidden = true
        inputLayout2.isHidden = true
        subNameEdit.text = ""
        subAddr1Edit.text = ""
        subAddr2Edit.text = ""
        subTypeEdit.text = ""
        if let code = mKyc["jobcode"] as? String{
            if(code == "1"){
                subTitle1 = "직장명"
                subTitle2 = "직장 주소"
                subTitle3 = "직종"
                subTitle4 = "직장 주소 검색"
                subTitle5 = "직장명을 입력해 주세요."
                subTitle6 = "직종을 선택해 주세요."
            }else if(code == "2"){
                subTitle1 = "상호명"
                subTitle2 = "사업장 주소"
                subTitle3 = "업종"
                subTitle4 = "사업장 주소 검색"
                subTitle5 = "사업장명을 입력해 주세요."
                subTitle6 = "업종을 선택해 주세요."
            }
            if(code == "1" || code == "2"){
                subNameText.text = subTitle1
                subAddrText.text = subTitle2
                subTypeText.text = subTitle3
                subAddr1Edit.placeholder = subTitle4
                subNameEdit.placeholder = subTitle5
                subTypeEdit.placeholder = subTitle6
                inputLayout1.isHidden = false
            }
            
        }
        inputLayout2.isHidden = false
    }
    
    
    
    fileprivate func stop(){
        self.navigationController?.dismiss(animated: true)
    }
    
    
    func openAddrPopup() {
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
    
    @IBAction func nextStep(_ sender: Any) {
        if let error = error(){
            showErrorDialog(error)
            return
        }
        setNextStep()
    }
    
    fileprivate func error() -> String?{
        guard let code = mKyc["jobcode"] as? String else{
            return "직업을 선택해 주세요"
        }
        
        if(code == "1"){
            mKyc["jobName"] = subNameEdit.text!
            mKyc["jobdetailAddress"] = subAddr2Edit.text!
            if(subNameEdit.text! == ""){
                return "직장명을 입력해 주세요."
            }
            if(subAddr1Edit.text! == ""){
                return "주소를 입력해 주세요."
            }
            if(subAddr2Edit.text! == ""){
                return "나머지 주소를 입력해 주세요."
            }
            if(subTypeEdit.text! == ""){
                return "직종을 선택해 주세요."
            }
        }
        if(code == "2"){
            mKyc["jobName"] = subNameEdit.text!
            mKyc["jobdetailAddress"] = subAddr2Edit.text!
            if(subNameEdit.text! == ""){
                return "상호명을 입력해 주세요."
            }
            if(subAddr1Edit.text! == ""){
                return "주소를 입력해 주세요."
            }
            if(subAddr2Edit.text! == ""){
                return "나머지 주소를 입력해 주세요."
            }
            if(subTypeEdit.text! == ""){
                return "업종을 선택해 주세요."
            }
        }
        
        if(puposeEdit.text! == ""){
            return "거래목적을 선택해 주세요"
        }
        if(fundEdit.text! == ""){
            return "거래자금출처를 선택해 주세요"
        }
        if(!myFund){
            return "실소유자가 아닌 경우 고객확인을 완료할 수 없습니다."
        }
        return nil
    }
    
    fileprivate func setNextStep(){
        let request = Kyc3UploadRequest()
        request.work_nm = mKyc["jobName"] as? String
        request.job_ds_c = mKyc["jobcode"] as? String
        request.job_dtl_ds_c = mKyc["jobtype"] as? String
        request.bzmn_bzc_ds_c = mKyc["businesstype"] as? String
        request.tran_fund_source_div = mKyc["source"] as? String
        request.tran_fund_source_nm = mKyc["source_name"] as? String
        request.account_new_purpose_cd = mKyc["purpose"] as? String
        request.account_new_purpose_nm = mKyc["purpose_name"] as? String
        request.actlownr_yn = "Y"
        request.work_addr = ""
        request.work_post_no = ""
        request.work_dtl_addr = ""
        request.work_addr_display_div = ""
        
        if let code = mKyc["jobcode"] as? String{
            if(code == "1" || code == "2"){
                request.work_addr =  subAddr1Edit.text ?? ""
                request.work_post_no = mKyc["jobzonecode"] as? String ?? ""
                request.work_dtl_addr =  subAddr2Edit.text ?? ""
                request.work_addr_display_div = "KR"
            }
        }
        
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? Kyc3UploadRequest{
            let data = Kyc3UploadResponse(baseResponce: response)
            guard let result = data.getResult_cd() else {
                self.showErrorDialog("인증에 실패했습니다. 다시 실행해 주세요")
                return
            }
            
            if (result == "y"){
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kyc4vc") as? VCKyc4
                pushVC?.mKyc["krName"] = mKyc["krName"] as? String
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
    
    @objc func onClicked(sender:UITapGestureRecognizer){
        if sender.view == backBtn {
            stop()
        }else if(sender.view == jobSelectBtn){
            let delegate:((KycVo.SMAP) -> ())? = {[weak self] item in
                self?.onSelect(item, self?.JOBSELECT)
            }
            startDropDown("직업 선택", delegate, KycVo().makeJob())
        }else if(sender.view == puposeSelectBtn){
            let delegate:((KycVo.SMAP) -> ())? = {[weak self] item in
                self?.mKyc["purpose"] = item.value
                self?.mKyc["purpose_name"] = item.key
                self?.puposeEdit.text = item.key
            }
            startDropDown("거래 목적 선택", delegate, KycVo().makePorpose())
        }else if(sender.view == fundEdit){
            let delegate:((KycVo.SMAP) -> ())? = {[weak self] item in
                self?.mKyc["source"] = item.value
                self?.mKyc["source_name"] = item.key
                self?.fundEdit.text = item.key
            }
            startDropDown("자금 원천 선택", delegate, KycVo().makeSource())
        }else if(sender.view == subTypeBtn){
            if let code = mKyc["jobcode"] as? String{
                if code == "1"{
                    let delegate:((KycVo.SMAP) -> ())? = {[weak self] item in
                            self?.mKyc["jobtype"] = item.value
                            self?.mKyc["jobtypename"] = item.key
                            self?.subTypeEdit.text = item.key
                    }
                    startDropDown("직종 선택", delegate, KycVo().makeJob2())
                }
                if code == "2"{
                    let delegate:((KycVo.SMAP) -> ())? = {[weak self] item in
                            self?.mKyc["businesstype"] = item.value
                            self?.mKyc["businesstypename"] = item.key
                            self?.subTypeEdit.text = item.key
                    }
                    startDropDown("업종 선택", delegate, KycVo().makeJob3())
                }
            }
        }else if(sender.view == addrBtn){
            openAddrPopup();
        }else if(sender.view == yesBtn || sender.view == yesText){
            myFund = true
            setMyFund();
        }else if(sender.view == noBtn || sender.view == noText){
            myFund = false
            setMyFund();
        }
    }
    
    fileprivate func setMyFund(){
        if(myFund){
            yesBtn.image = UIImage(named: "mytrade_check_active")
            noBtn.image = UIImage(named: "mytrade_check_deactive")
        }else{
            yesBtn.image = UIImage(named: "mytrade_check_deactive")
            noBtn.image = UIImage(named: "mytrade_check_active")
        }
    }
    
    func onSelect(_ item:KycVo.SMAP,_ CATE: Int?) {
        
        if CATE ?? 0 == JOBSELECT {
            mKyc["jobcode"] = item.value
            mKyc["jobName"] = item.key
            jobEdit.text = item.key
            
            if(item.value == "2"){
                mKyc["jobtype"] = "18"
                mKyc["jobtypename"] = "자영업자/개인사업자"
            }else if(item.value == "3"){
                mKyc["jobtype"] = "98"
                mKyc["jobtypename"] = "무직"
            }else if(item.value == "4"){
                mKyc["jobtype"] = "92"
                mKyc["jobtypename"] = "학생"
            }else if(item.value == "5"){
                mKyc["jobtype"] = "91"
                mKyc["jobtypename"] = "주부"
            }
            
            jobOptionVisible()
        }
    }
    
}



extension VCKyc3: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if(textField == subNameEdit){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 20 else { return false }
            }
            if(textField == subAddr2Edit){
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
        textField.background = UIImage(named: "text_field_active.png")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.background = UIImage(named: "text_field_inactive.png")
    }
    
    fileprivate func startDropDown(_ titleString:String, _ delegate:((KycVo.SMAP) -> ())?,_ array:Array<KycVo.SMAP>){
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "PopupKyc") as? PopupKyc else {
            return
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.mArray = array
        vc.titleString = titleString
        vc.delegate = delegate
        self.present(vc, animated: true);
    }
}

