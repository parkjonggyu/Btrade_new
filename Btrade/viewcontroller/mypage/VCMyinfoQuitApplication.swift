//
//  VCMyinfoQuitApplication.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/26.
//

import Foundation
import Alamofire

class VCMyinfoQuitApplication: VCBase, AuthTimerInterface {
    
    
    var totalAsset:String?
    
    var emailAuth = false
    var emailAuthOk = false
    var agree1Checked = false
    var agree2Checked = false

    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var pwText: UITextField!
    
    @IBOutlet weak var totalAssetText: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    
    @IBOutlet weak var check1Image: UIButton!
    @IBOutlet weak var check1Btn: UIStackView!
    
    @IBOutlet weak var check2Image: UIButton!
    @IBOutlet weak var check2Btn: UIStackView!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var authText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(totalAsset == nil){
            stop()
            return
        }
        
        pwText.delegate = self
        authText.delegate = self
        pwText.background = UIImage(named: "text_field_inactive.png")
        authText.background = UIImage(named: "text_field_inactive.png")
        
        totalAssetText.text = totalAsset! + " KRW"
        self.authBtn.titleLabel?.text = "인증요청"
        timerText.text = ""
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        check1Btn.isUserInteractionEnabled = true
        check1Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        check2Btn.isUserInteractionEnabled = true
        check2Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        
        ApiFactory(apiResult: self, request: MemberInfoNoMaskRequest()).newThread()
        
    }
    
    var timer:AuthTimer?
    func initTimer(){
        if(timer != nil){return}
        timer = AuthTimer(1000*60*10, self, timerText)
        timer?.start()
    }
    
    func endTimer() {
        stop()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? MemberInfoNoMaskRequest{
            let data = MemberInfoNoMaskRespose(baseResponce: response)
            if let email = data.getId(){
                emailText.text = email
            }
        }
        if let _ = response.request as? InactiveEmailRequest{
            let data = InactiveEmailResponse(baseResponce: response)
            if let code = data.getCode(){
                DispatchQueue.main.async{
                    if(code != "200"){
                        self.showErrorDialog("이메일 발송에 실패했습니다.")
                        return
                    }
                    self.emailAuth = true
                    self.authBtn.titleLabel?.text = "확인"
                    self.initTimer()
                }
            }
        }
        if let _ = response.request as? InactiveEmailConfirmRequest{
            let data = InactiveEmailConfirmResponse(baseResponce: response)
            if let code = data.getCode(){
                DispatchQueue.main.async{
                    if(code != "200"){
                        if let msg = data.getMessage(){
                            self.showErrorDialog(msg)
                        }else{
                            self.showErrorDialog("인증에 실패했습니다.")
                        }
                        return
                    }
                    self.emailAuthOk = true
                    self.authBtn.titleLabel?.text = "확인 완료"
                    self.timer?.stop()
                    self.timerText.text = "인증 완료"
                    self.authBtn.isEnabled = false
                    self.authText.isEnabled = false
                }
            }
        }
        
        if let _ = response.request as? MyInfoQuitRequest{
            DispatchQueue.main.async{
                let data = MyInfoQuitResponse(baseResponce: response)
                if let status = data.getState(){
                    if(status == "OK"){
                        DialogUtils().makeDialog(
                        uiVC: self,
                        title: "회원탈퇴",
                        message:"정상적으로 회원 탈퇴하였습니다.",
                        BtradeAlertAction(title: "확인", style: .default) { (action) in
                            self.appInfo.deleteCookie()
                            self.stop()
                        })
                        
                        
                        return
                    }else{
                        if let msg = data.getMsg(){
                            self.showErrorDialog(msg)
                            return
                        }
                    }
                }
                self.showErrorDialog("탈퇴하지 못했습니다. 관리자에게 문의하세요.")
            }
        }
        
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    
    @IBAction func goNext(_ sender: Any) {
        if let pw = passwordInputCheck(){
            showErrorDialog(pw)
            return
        }
        
        if(!agree1Checked || !agree2Checked){
            showErrorDialog("약관 동의를 체크해 주세요.")
            return
        }
        
        if(!emailAuth || !emailAuthOk){
            showErrorDialog("이메일 인증을 진행해 주세요.")
            return
        }
        
        if let pw = pwText.text{
            let request = MyInfoQuitRequest()
            request.prev_passwd = pw.toBase64()
            ApiFactory(apiResult: self, request: request).newThread()
        }
    }
    
    @IBAction func goAuth(_ sender: Any) {
        if(emailAuth){
            if(!emailAuthOk){
                if let auth = authText.text{
                    if(auth.count != 6){
                        showErrorDialog("인증번호 6자리를 입력해 주세요")
                        return
                    }
                    let request = InactiveEmailConfirmRequest()
                    request.mb_id = emailText.text!
                    request.token = authText.text!
                    ApiFactory(apiResult: self, request: request).newThread()
                }
            }
        }else{
            let request = InactiveEmailRequest()
            request.email = emailText.text!
            ApiFactory(apiResult: self, request: request).newThread()
        }
    }
    
    @objc func clickedBtn(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            stop()
        }else if(sender.view == check1Btn){
            agree1Checked = !agree1Checked
            setCheckBox(imageBtn: check1Image, checked: agree1Checked)
        }else if(sender.view == check2Btn){
            agree2Checked = !agree2Checked
            setCheckBox(imageBtn: check2Image, checked: agree2Checked)
        }
    }
    
    fileprivate func setCheckBox(imageBtn:UIButton, checked:Bool){
        if(checked){
            imageBtn.setImage(UIImage(named: "check_active.png") , for: .normal)
        }else{
            imageBtn.setImage(UIImage(named: "check_inactive.png") , for: .normal)
        }
    }
    
    fileprivate func passwordInputCheck() -> String?{
        if let pw = pwText.text{
            if(pw == ""){return "비밀번호를 입력하세요."}
            if(!passwordCheck(input: pwText.text!)){return "패스워드 형식이 올바르지 않습니다."}
            return nil
        }
        
        return "비밀번호를 입력하세요."
    }
    
    func passwordCheck(input:String) -> Bool {
        let pattern = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$!%*#?&])[A-Za-z[0-9]$@$!%*#?&]{7,15}"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return true
        }
        return false
    }
    
    fileprivate func stop(){
        UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
        //self.dismiss(animated: true)
    }
}

extension VCMyinfoQuitApplication: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == pwText){
            if((textField.text! + string).count > 15 && string.count > 0){ return false }
        }else if(textField == authText){
            if((textField.text! + string).count > 6 && string.count > 0){ return false }
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
