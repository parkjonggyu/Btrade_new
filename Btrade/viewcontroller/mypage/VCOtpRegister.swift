//
//  VCOtpRegister.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/24.
//

import Foundation
import Alamofire


class VCOtpRegister: VCBase {
    
    @IBOutlet weak var goGoogleRound: UIView!
    @IBOutlet weak var googleCodeLayout: UIView!
    @IBOutlet weak var copyBtn: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var qrcodeNum: UILabel!
    
    @IBOutlet weak var codeEdit: UITextField!
    @IBOutlet weak var repareView: UIView!
    @IBOutlet weak var repareBtn: UILabel!
    @IBOutlet weak var repareText: UILabel!
    
    @IBOutlet weak var repareRound: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        goGoogleRound.layer.borderWidth = 2
        goGoogleRound.layer.borderColor = UIColor.gray.cgColor
        goGoogleRound.layer.cornerRadius = goGoogleRound.frame.height / 2
        
        googleCodeLayout.layer.borderWidth = 2
        googleCodeLayout.layer.borderColor = UIColor.systemBlue.cgColor
        googleCodeLayout.layer.cornerRadius = 3
        
        repareView.layer.borderWidth = 2
        repareView.layer.borderColor = UIColor.systemBlue.cgColor
        repareView.layer.cornerRadius = 3
        
        repareRound.layer.cornerRadius = 10
        
        copyBtn.isUserInteractionEnabled = true
        copyBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        
        repareBtn.isUserInteractionEnabled = true
        repareBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
       
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        
        goGoogleRound.isUserInteractionEnabled = true
        goGoogleRound.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        
        codeEdit.delegate = self
        
        ApiFactory(apiResult: OtpGenerate(self), request: OtpGenerateRequest()).newThread()
    }
    
    class OtpGenerate:ApiResult{
        weak var parent: VCOtpRegister!
        
        init(_ a: VCOtpRegister) {
            self.parent = a
        }
        
        func onResult(response: BaseResponse) {
            if let _ = response.request as? OtpGenerateRequest{
                let data = OtpGenerateResponse(baseResponce: response)
                if let result = data.getResult(){
                    self.parent.setData(result)
                    return
                }
                
                DispatchQueue.main.async{self.parent.stop()}
            }
        }
        
        func onError(e: AFError, method: String) {}
    }
  
    fileprivate func setData(_ result:NSDictionary){
        DispatchQueue.main.async{
            if let qrcode = result["qrcode"] as? String{
                if let i = self.generateQRCode(qrcode){
                    self.qrcodeImage.image = i
                }
            }
            if let mb_google_otp_key = result["mb_google_otp_key"] as? String{
                self.qrcodeNum.text = mb_google_otp_key
            }
            if let mb_recovery_code = result["mb_recovery_code"] as? String{
                self.repareText.text = mb_recovery_code
            }
        }
    }
    
    @IBAction func registerOtp(_ sender: Any) {
        let code = codeEdit.text!
        if code.count != 6{
            showToast("OTP 인증번호 6자리를 입력하세요.")
        }
        
        let request = OtpRegisterRequest()
        request.otp = codeEdit.text!
        request.mb_google_otp_key = qrcodeNum.text!
        request.mb_recovery_code = repareText.text!
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? OtpRegisterRequest{
            let data = OtpRegisterResponse(baseResponce: response)
            if let status = data.getState(){
                if status == "OK"{
                    showErrorDialog("OTP 등록이 완료 되었습니다."){_ in
                        if let _ = self.appInfo.memberInfo{
                            self.appInfo.memberInfo?.update = true
                        }
                        UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
                    }
                    return
                }
            }
            
            if let msg = data.getMsg(){
                showErrorDialog(msg);
            }
        }
    }
    
    @objc func clickedBtn(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            stop()
        }else if(sender.view == copyBtn){
            if qrcodeNum.text != nil && qrcodeNum.text!.count > 0{
                UIPasteboard.general.string = qrcodeNum.text!
                showToast("주소키가 복사 되었습니다.")
            }
        }else if(sender.view == repareBtn){
            if repareText.text != nil && repareText.text!.count > 0{
                UIPasteboard.general.string = repareText.text!
                showToast("복구코드가 복사 되었습니다.")
            }
        }else if(sender.view == goGoogleRound){
            openAppStore()
        }
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    func generateQRCode(_ string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func openAppStore() {
        let url = "itms-apps://itunes.apple.com/app/id1538761576"
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension VCOtpRegister: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "codeedit"){
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
}
