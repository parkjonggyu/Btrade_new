    //
    //  VCKyc3.swift
    //  Btrade
    //
    //  Created by 블록체인컴퍼니 on 2022/08/02.
    //

import Alamofire
import UIKit

class VCKyc3: VCBase, WebResult , SpinnerSelectorInterface{
    
    var mKyc:Dictionary<String, Any> = Dictionary<String, Any>()
    var isAddr2Check = false
    
    let JOBSELECT = 10, PURPOSE = 11, FUND = 12
    var WHERE = 10
    
    @IBOutlet weak var jobDetailsLayout: UIStackView!
    @IBOutlet weak var kyc3_job_select: UITextField!
    @IBOutlet weak var kyc3_transaction_purpose: UITextField!
    @IBOutlet weak var kyc3_fund_source: UITextField!
    
    @IBOutlet weak var jobNameEdit: UITextField!
    @IBOutlet weak var addr1Edit: UITextField!
    @IBOutlet weak var addr2Edit: UITextField!
    
    
    @IBOutlet weak var addrCheck: UIButton!
    @IBOutlet weak var addrCheckText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mKyc["isJobOptions"] = true
        
        jobNameEdit.delegate = self
        addr2Edit.delegate = self
        kyc3_job_select.delegate = self
        kyc3_transaction_purpose.delegate = self
        kyc3_fund_source.delegate = self
        
        
        addr1Edit.isUserInteractionEnabled = false
        
        addrCheckText.isUserInteractionEnabled = true
        addrCheckText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addrCheckView1)))
        
        setRightIcon(kyc3_job_select)
        setRightIcon(kyc3_transaction_purpose)
        setRightIcon(kyc3_fund_source)
    }
    
    fileprivate func setRightIcon(_ textField:UITextField){
        let width: CGFloat = 10
        let height: CGFloat = 6
        let image = UIImage(named: "text_field_bottom_arrow.png");
        let padding: CGFloat = 8
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: padding * 2 + width, height: height))
        let imageView = UIImageView(frame: CGRect(x: padding, y: 0, width: width, height: height))
        imageView.image = image
        outerView.addSubview(imageView)
        textField.rightView = outerView // Or rightView = outerView
        textField.rightViewMode = .always
    }
    
    func result(_ map: Dictionary<String, Any>) {
        for (key,value) in map{
            mKyc["job" + key] = value
        }
        setTextInView()
    }
    
    fileprivate func setTextInView(){
        if mKyc["jobroadAddress"] != nil {
            addr1Edit.text = mKyc["jobroadAddress"] as! String + " " + (mKyc["jobbuildingName"] as? String ?? "")
        }else if mKyc["jobautoJibunAddress"] != nil{
            addr1Edit.text = mKyc["ajobutoJibunAddress"] as? String
        }else if mKyc["jobjibunAddress"] != nil{
            addr1Edit.text = mKyc["jobjibunAddress"] as? String
        }
    }
    
    fileprivate func jobOptionVisible(){
        if let code = mKyc["jobcode"] as? String{
            if(code == "04" || code == "14" || code == "15" || code == "16"){
                mKyc["isJobOptions"] = false
                self.jobDetailsLayout.layer.isHidden = true
            }else{
                mKyc["isJobOptions"] = true
                self.jobDetailsLayout.layer.isHidden = false
            }
        }
    }
    
    @objc
    func addrCheckView1(sender:UITapGestureRecognizer){
        addrCheckView()
    }
    
    @IBAction func addrCheckView(_ sender: Any) {
        addrCheckView()
    }
    
    fileprivate func addrCheckView(){
        isAddr2Check = !isAddr2Check
        if(isAddr2Check){
            addrCheck.setImage(UIImage(named: "check_active.png") , for: .normal)
            addr2Edit.isUserInteractionEnabled = false
            addr2Edit.text = ""
            addr2Edit.placeholder = "나머지 주소 없음"
        }else{
            addrCheck.setImage(UIImage(named: "check_inactive.png") , for: .normal)
            addr2Edit.isUserInteractionEnabled = true
            addr2Edit.placeholder = "나머지 주소를 입력해 주세요."
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        stop()
    }
    
    fileprivate func stop(){
        self.navigationController?.dismiss(animated: true)
    }
    
    
    @IBAction func openAddrPopup(_ sender: Any) {
        let sb = UIStoryboard.init(name:"Webview", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "webvc") as? VCWeb else {
            return
        }
        vc.page = BuildConfig.SERVER_URL + "m/mypage/kycAuth/addr.do"
        vc.smsDelegate = self
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
        if(mKyc["jobcode"] == nil){
            return "직업을 선택해 주세요"
        }
        if(mKyc["purpose"] == nil){
            return "거래목적을 선택해 주세요"
        }
        if(mKyc["source"] == nil){
            return "거래자금출처를 선택해 주세요"
        }
        
        
        
        if let option = mKyc["isJobOptions"] as? Bool{
            if(option){
                guard let _ = jobNameEdit.text else {
                    return "직장명을 입력해 주세요"
                }
                if jobNameEdit.text == "" {
                    return "직장명을 입력해 주세요"
                }
                
                guard let _:String = addr1Edit.text else {
                    return "주소을 입력해 주세요"
                }
                if addr1Edit.text == "" {
                    return "주소을 입력해 주세요"
                }
                
                if(!isAddr2Check){
                    guard let _:String = addr2Edit.text else {
                        return "나머지 주소을 입력해 주세요"
                    }
                    if addr2Edit.text == "" {
                        return "나머지 주소을 입력해 주세요"
                    }
                }
            }
        }
        return nil
    }
    
    fileprivate func setNextStep(){
        let request = Kyc3UploadRequest()
        request.work_nm = jobNameEdit.text!
        request.business_dtl_cd = mKyc["jobcode"] as? String
        request.work_addr_display_div = "KR"
        request.work_post_no = mKyc["jobzonecode"] as? String
        request.work_addr = (mKyc["jobroadAddress"] as! String) + " " + (mKyc["jobbuildingName"] as? String ?? "")
        request.work_dtl_addr = addr2Edit.text!
        request.tran_fund_source_div = mKyc["source"] as? String
        request.tran_fund_source_nm = mKyc["source_name"] as? String
        
        request.account_new_purpose_cd = mKyc["purpose"] as? String
        request.account_new_purpose_nm = mKyc["purpose_name"] as? String
        ApiFactory(apiResult: self, request: request).netThread()
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
    
    func onSelect(_ item:KycVo.SMAP,_ CATE: Int) {
        
        if CATE == JOBSELECT {
            mKyc["jobcode"] = item.value
            mKyc["jobName"] = item.key
            kyc3_job_select.text = item.key
            jobOptionVisible()
        }else if CATE == PURPOSE {
            mKyc["purpose"] = item.value
            mKyc["purpose_name"] = item.key
            kyc3_transaction_purpose.text = item.key
        }else if CATE == FUND {
            mKyc["source"] = item.value
            mKyc["source_name"] = item.key
            kyc3_fund_source.text = item.key
        }
    }
    
}



extension VCKyc3: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "jobedit"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 15 else { return false }
            }
            if(id == "detailaddr"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 20 else { return false }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let id = textField.restorationIdentifier{
            if(id == "jobselect1"){
                startDropDown(textField, KycVo().makeJob(), JOBSELECT)
                return
            }else if(id == "purposeselect"){
                startDropDown(textField, KycVo().makePorpose(), PURPOSE)
                return
            }else if(id == "sourceselect"){
                startDropDown(textField, KycVo().makeSource(), FUND)
                return
            }
            
            textField.background = UIImage(named: "text_field_active.png")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _ = textField.restorationIdentifier{
            textField.background = UIImage(named: "text_field_inactive.png")
        }
    }
    
    fileprivate func startDropDown(_ textField: UITextField,_ array:Array<KycVo.SMAP>,_ WHERE:Int){
        textField.endEditing(true)
        SpinnerSelector(self, textField, array, WHERE).start()
    }
}

