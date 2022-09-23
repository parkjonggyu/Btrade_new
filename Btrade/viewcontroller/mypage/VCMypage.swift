//
//  VCMypage.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/05.
//

import Foundation
import Alamofire
import ImageSlideshow

class VCMypage: VCBase {
    
    @IBOutlet weak var loggedOutLayout: UIView!
    @IBOutlet weak var loggedInLayout: UIView!
    @IBOutlet weak var cornerView: UIImageView!
    
    @IBOutlet weak var myPageEvent: ImageSlideshow!
    
    @IBOutlet weak var allStack: UIStackView!
    @IBOutlet weak var loginBtn: UILabel!
    @IBOutlet weak var signupBtn: UILabel!
    
    @IBOutlet weak var notificationsImage: UIView!
    @IBOutlet weak var customerSupport: UIView!
    @IBOutlet weak var settingImage: UIView!
    
    
    @IBOutlet weak var tradeLevelTextView: UILabel!
    @IBOutlet weak var emailTextView: UILabel!
    @IBOutlet weak var certifyLevelTextView: UILabel!
    @IBOutlet weak var usernameTextView: UILabel!
    
    
    @IBOutlet weak var noticeText1: UILabel!
    @IBOutlet weak var noticeText2: UILabel!
    @IBOutlet weak var noticeText3: UILabel!
    @IBOutlet weak var noticeText4: UILabel!
    @IBOutlet weak var noticeText5: UILabel!
    @IBOutlet weak var noticeAll1: UILabel!
    @IBOutlet weak var noticeAll2: UILabel!
    
    @IBOutlet weak var faqLayout: UIStackView!
    @IBOutlet weak var csMenu3Layout: UIStackView!
    @IBOutlet weak var csMenu2Layout: UIStackView!
    
    @IBOutlet weak var certifyButton: UIButton!
    @IBOutlet weak var myInfoBtn: UIButton!
    let images = [
        AlamofireSource.init(urlString: "https://www.btrade.co.kr/2.png", placeholder: UIImage(named: "eventtest.png"))!,
        AlamofireSource.init(urlString: "https://www.btrade.co.kr/2.png", placeholder: UIImage(named: "eventtest.png"))!,
    ]
    
    var allList:Array<Notice> = Array<Notice>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VCMypage - viewDidLoad")
        myPageEvent.setImageInputs(images)
        myPageEvent.slideshowInterval = 3
        myPageEvent.contentScaleMode = .scaleAspectFill
        myPageEvent.clipsToBounds = true
        myPageEvent.layer.cornerRadius = 25
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        myPageEvent.addGestureRecognizer(gestureRecognizer)
        

//        signup.isUserInteractionEnabled = true
        //        signup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(visibleLogoutLayout)))
        noticeAll1.isUserInteractionEnabled = true
        noticeAll2.isUserInteractionEnabled = true
        noticeAll1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        noticeAll2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        
        faqLayout.isUserInteractionEnabled = true
        faqLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        csMenu2Layout.isUserInteractionEnabled = true
        csMenu2Layout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        csMenu3Layout.isUserInteractionEnabled = true
        csMenu3Layout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        certifyButton.isUserInteractionEnabled = true
        certifyButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        myInfoBtn.isUserInteractionEnabled = true
        myInfoBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        loginBtn.isUserInteractionEnabled = true
        loginBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        signupBtn.isUserInteractionEnabled = true
        signupBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
        
        
        
        noticeText1.text = ""
        noticeText2.text = ""
        noticeText3.text = ""
        noticeText4.text = ""
        noticeText5.text = ""
        
        noticeText1.isUserInteractionEnabled = true
        noticeText2.isUserInteractionEnabled = true
        noticeText3.isUserInteractionEnabled = true
        noticeText4.isUserInteractionEnabled = true
        noticeText5.isUserInteractionEnabled = true
        
        
        
        cornerView.clipsToBounds = true
        cornerView.layer.cornerRadius = 25
        notificationsImage.clipsToBounds = true
        notificationsImage.layer.cornerRadius = 25
        customerSupport.clipsToBounds = true
        customerSupport.layer.cornerRadius = 25
        settingImage.clipsToBounds = true
        settingImage.layer.cornerRadius = 25
        
        loggedOutLayout.layer.isHidden = true
        loggedInLayout.layer.isHidden = true
        
        if(appInfo.getMemberInfo() == nil){
            visibleLogoutLayout()
        }else{
            setMemberInfo(appInfo.getMemberInfo()!)
        }
        
        
        ApiFactory(apiResult: self, request: NoticeSampleRequest()).netThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? NoticeSampleRequest{
            let data = NoticeSampleResponse(baseResponce: response)
            
            let importantList = data.getSample()
            var idx = 0
            if(importantList != nil){
                for item in importantList!{
                    let notice = Notice(bn_idx: item["bn_idx"] as? Int, bn_title: item["bn_title"] as? String, bn_contents: item["bn_contents"] as? String, reg_date: item["reg_date"] as? String, mod_date: item["mod_date"] as? String, searchValue: item["searchValue"] as? String, important: true ,sequence:idx)
                    allList.append(notice)
                    idx += 1
                }
                
                DispatchQueue.main.async{
                    if let board = self.allList[0] as? Notice{
                        self.noticeText1.text = board.bn_title;
                        self.noticeText1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
                    }
                    if let board = self.allList[1] as? Notice{
                        self.noticeText2.text  = board.bn_title;
                        self.noticeText2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
                    }
                    if let board = self.allList[2] as? Notice{
                        self.noticeText3.text = board.bn_title;
                        self.noticeText3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
                    }
                    if let board = self.allList[3] as? Notice{
                        self.noticeText4.text = board.bn_title;
                        self.noticeText4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
                    }
                    if let board = self.allList[4] as? Notice{
                        self.noticeText5.text = board.bn_title;
                        self.noticeText5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToNotice)))
                    }
                }
            }
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    @objc
    func goToNotice(sender:UITapGestureRecognizer){
        
        if(sender.view == noticeText1){
            gotoNotice(0)
        }else if(sender.view == noticeText2){
            gotoNotice(1)
        }else if(sender.view == noticeText3){
            gotoNotice(2)
        }else if(sender.view == noticeText4){
            gotoNotice(3)
        }else if(sender.view == noticeText5){
            gotoNotice(4)
        }else if(sender.view == noticeAll1 || sender.view == noticeAll2){
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "boardnoticevc") as? VCBase else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true);
        }else if(sender.view == faqLayout){
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "faqvc") as? VCBase else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true);
        }else if(sender.view == csMenu3Layout){
            gotoCs_menu3()
        }else if(sender.view == csMenu2Layout){
            guard let url = URL(string: "https://pf.kakao.com/_ixhFxhC/chat") else {return}
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else if(sender.view == certifyButton){
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "securitycertivc") as? VCSecurityCerti else {
                return
            }
            vc.refresh = {() in
                ApiFactory(apiResult: self, request: MemberInfoRequest()).netThread()
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true);
        }else if(sender.view == myInfoBtn){
            guard let mainvc = self.storyboard?.instantiateViewController(withIdentifier: "myinfovc") as? UINavigationController else {
                return
            }
            
            mainvc.modalPresentationStyle = .fullScreen
            self.present(mainvc, animated: true);
        }else if(sender.view == signupBtn){
            let sb = UIStoryboard.init(name:"Login", bundle: nil)
            guard let mainvc = sb.instantiateViewController(withIdentifier: "signupnav") as? UINavigationController else {
                return
            }
            
            mainvc.modalPresentationStyle = .fullScreen
            self.present(mainvc, animated: true);
        }else if(sender.view == loginBtn){
            let sb = UIStoryboard.init(name:"Login", bundle: nil)
            guard let mainvc = sb.instantiateViewController(withIdentifier: "loginvc") as? UINavigationController else {
                return
            }
            
            mainvc.modalPresentationStyle = .fullScreen
            self.present(mainvc, animated: true);
        }
    }
    
    
    
    fileprivate func gotoNotice(_ s:Int){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "boardnoticedetailvc") as? VCBoardNoticeDetail else {
            return
        }
        vc.array = allList
        vc.sequence = s
        vc.each = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
    @objc func didTap() {
        
    }
    
    fileprivate func gotoCs_menu3(){
        if(appInfo.getIsLogin()){
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "qnamainvc") as? UINavigationController else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true);
        }else{
            let sb = UIStoryboard.init(name:"Login", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: "loginvc") as? UINavigationController else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true);
        }
    }
    
    
    
    
    func setMemberInfo(_ memberInfo:MemberInfo){
        visibleLoginLayout(memberInfo)
    }
    
    fileprivate func visibleLogoutLayout(){
        loggedOutLayout.layer.isHidden = false
        loggedInLayout.layer.isHidden = false
        self.allStack.insertArrangedSubview(self.loggedOutLayout, at: 0)
        self.allStack.insertArrangedSubview(self.loggedInLayout, at: 0)
        self.loggedOutLayout.layer.isHidden = true
    }
    
    fileprivate func visibleLoginLayout(_ memberInfo:MemberInfo){
        let certify_lever = CoinUtils.getlevel(memberInfo)
        if(loggedOutLayout == nil){return}
            
        loggedOutLayout.layer.isHidden = false
        loggedInLayout.layer.isHidden = false
        self.allStack.insertArrangedSubview(self.loggedOutLayout, at: 0)
        self.allStack.insertArrangedSubview(self.loggedInLayout, at: 0)
        self.loggedInLayout.layer.isHidden = true
        DispatchQueue.main.async{
            if let name = memberInfo.nick_name{
                self.usernameTextView.text = name
            }else{
                self.usernameTextView.text = "회원"
            }
            
            if let id = memberInfo.id{
                self.emailTextView.text = id
            }else{
                self.emailTextView.text = ""
            }
            
            if(certify_lever == 2){
                self.certifyLevelTextView.text = "02"
                self.tradeLevelTextView.text = "가능"
            }else if(certify_lever == 3){
                self.certifyLevelTextView.text = "03"
                self.tradeLevelTextView.text = "가능"
            }else {
                self.certifyLevelTextView.text = "01"
                self.tradeLevelTextView.text = "불가능"
            }
        }
    }
}
