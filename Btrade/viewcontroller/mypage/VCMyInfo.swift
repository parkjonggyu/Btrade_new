//
//  VCMyInfo.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/25.
//

import Foundation
import Alamofire


class VCMyInfo: VCBase {
    var refresh:(() -> Void)?
    
    @IBOutlet weak var backBtn: UIImageView!
    
    @IBOutlet weak var leaveLayout: UIView!
    @IBOutlet weak var logoutLayout: UIView!
    @IBOutlet weak var pwLayout: UIView!
    @IBOutlet weak var optionLayout: UIView!
    
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var nickText: UILabel!
    
    @IBOutlet weak var jobLayout: UIView!
    @IBOutlet weak var myInfoLayout: UIView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var phoneText: UILabel!
    @IBOutlet weak var bankAccountText: UILabel!
    @IBOutlet weak var homeAddressText: UILabel!
    @IBOutlet weak var btnMasking: UIImageView!
    
    @IBOutlet weak var worknmText2: UILabel!
    @IBOutlet weak var worknmText1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(appInfo.getMemberInfo() == nil){
            stop()
            return
        }
        
        initView()
        
        optionLayout.layer.borderWidth = 2
        optionLayout.layer.borderColor = UIColor.gray.cgColor
        optionLayout.layer.cornerRadius = 10
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        
        leaveLayout.isUserInteractionEnabled = true
        leaveLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        logoutLayout.isUserInteractionEnabled = true
        logoutLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        pwLayout.isUserInteractionEnabled = true
        pwLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        optionLayout.isUserInteractionEnabled = true
        optionLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        btnMasking.isUserInteractionEnabled = true
        btnMasking.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        nickText.isUserInteractionEnabled = true
        nickText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        
        
    }
    
    fileprivate func logout(){
        ApiFactory(apiResult: MemberInfo1(self), request: LogoutRequest()).netThread()
    }
    
    class MemberInfo1:ApiResult{
        let vcMyInfo : VCMyInfo
        init(_ vcMyInfo : VCMyInfo){
            self.vcMyInfo = vcMyInfo
        }
        func onResult(response: BaseResponse) {
            if let _ = response.request as? LogoutRequest{
                vcMyInfo.appInfo.deleteCookie()
                vcMyInfo.stop()
            }
        }
        
        func onError(e: AFError, method: String) {
            
        }
    }
    
    @objc
    func goToNotice(sender:UITapGestureRecognizer){
        if(sender.view == leaveLayout){
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "myinfoleavevc") as? VCBase else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true);
        }else if(sender.view == logoutLayout){
            DialogUtils().makeDialog(
            uiVC: self,
            title: "마이페이지",
            message:"로그아웃 하시겠습니까?",
            UIAlertAction(title: "로그아웃", style: .default) { (action) in
                self.logout()
            },
            UIAlertAction(title: "취소", style: .destructive) { (action) in
               
            })
        }else if(sender.view == pwLayout){
            guard let mainvc = self.storyboard?.instantiateViewController(withIdentifier: "myinfochangepassword") as? UINavigationController else {
                return
            }
            mainvc.modalPresentationStyle = .fullScreen
            self.present(mainvc, animated: true);
        }else if(sender.view == btnMasking){
            
        }else if(sender.view == optionLayout){
            guard let pvc = self.presentingViewController else { return }

            self.dismiss(animated: false) {
                let sb = UIStoryboard.init(name:"Kyc", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: "kycnavivc") as? UINavigationController else {
                    return
                }
                vc.modalPresentationStyle = .fullScreen
                pvc.present(vc, animated: false);
                return
            }
        }else if(sender.view == nickText){
            
        }
    }
    
    fileprivate func initView(){
        if let nick = appInfo.getMemberInfo()?.nick_name{
            nickText.text = nick
        }else{
            nickText.text = "닉네임을 등록해주세요."
        }
        
        if let email = appInfo.getMemberInfo()?.id{
            emailText.text = email
        }
        
        if let name = appInfo.getMemberInfo()?.full_name{
            nameText.text = name
        }
        
        if let phone = appInfo.getMemberInfo()?.phone_no{
            phoneText.text = phone
        }
        
        if let bname = appInfo.getMemberInfo()?.bankname , let bNum = appInfo.getMemberInfo()?.bankno{
            bankAccountText.text = bname + " | " + bNum
        }
        
        if let name = appInfo.getMemberInfo()?.work_nm{
            worknmText1.text = name
            worknmText2.text = name
        }
        
        
        if var addr = appInfo.getMemberInfo()?.mb_new_addr1{
            if let addr2 = appInfo.getMemberInfo()?.mb_new_addr2{
                addr = addr + " " + addr2
            }
            homeAddressText.text = addr
        }
        
        if let kyc = appInfo.getMemberInfo()?.aml_state{
            if(kyc == "cc"){
                setHiddenLayout(true)
            }else{
                setHiddenLayout(false)
            }
        }else{
            setHiddenLayout(false)
        }
        
    }
    
    fileprivate func setHiddenLayout(_ visible:Bool){
        optionLayout.isHidden = visible
        myInfoLayout.isHidden = !visible
        jobLayout.isHidden = !visible
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
}
