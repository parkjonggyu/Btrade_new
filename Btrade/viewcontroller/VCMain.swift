//
//  VCMain1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/06.
//

import UIKit
import Alamofire

class VCMain: VCBaseTab {
    
    var KYC = false
    
    var tabOne:UIViewController?
    var tabTwo:UIViewController?
    var tabThree:UIViewController?
    var tabFour:UIViewController?
    
    var loadLogin = false
    var setNavData:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let sbOne = UIStoryboard.init(name:"Trade", bundle: nil)
        tabOne = sbOne.instantiateViewController(withIdentifier: "tradevc")
        
        if(tabOne == nil){
            return
        }
        let tabOneBarItem = UITabBarItem(title: "거래소", image: UIImage(named: "progress1"), tag: 0)
        tabOne!.tabBarItem = tabOneBarItem
        
        
        let sbTwo = UIStoryboard.init(name:"Asset", bundle: nil)
        tabTwo = sbTwo.instantiateViewController(withIdentifier: "assetvc")
        if(tabTwo == nil){
            return
        }
        
        let tabTwoBarItem = UITabBarItem(title: "자 산", image: UIImage(named: "progress2"), tag: 1)
        tabTwo!.tabBarItem = tabTwoBarItem
        
        let sbThree = UIStoryboard.init(name:"Finance", bundle: nil)
        tabThree = sbThree.instantiateViewController(withIdentifier: "financevc")
        if(tabThree == nil){
            return
        }
        let tabThreeBarItem = UITabBarItem(title: "입출금", image: UIImage(named: "progress3"), tag: 2)
        tabThree!.tabBarItem = tabThreeBarItem
        
        let sbFour = UIStoryboard.init(name:"Mypage", bundle: nil)
        tabFour = sbFour.instantiateViewController(withIdentifier: "mypagevc")
        if(tabFour == nil){
            return
        }
        
        let tabFourBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "progress4"), tag: 3)
        
        tabFour!.tabBarItem = tabFourBarItem
        
        self.viewControllers = [tabOne!, tabTwo!, tabThree!, tabFour!]
        
        if(appInfo.isKycVisible){
            appInfo.isKycVisible = false;
            goKYC()
        }
        
        if(loadLogin){
            loadLogin = false
            var _ = self.startLogIn()
        }
        
        if let nav = setNavData{
            setNavData = nil
            if(nav == "tradevc"){
                self.selectedIndex = 0
            }else if(nav == "assetvc"){
                self.selectedIndex = 1
            }else if(nav == "financevc"){
                self.selectedIndex = 2
            }else if(nav == "mypagevc"){
                self.selectedIndex = 3
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkMemberInfo()
    }
    
    fileprivate func checkMemberInfo(){
        if(appInfo.getIsLogin()){
            if(appInfo.getMemberInfo() == nil || appInfo.getMemberInfo()?.update ?? false){
                ApiFactory(apiResult: MemberInfo2(self), request: MemberInfoRequest()).newThread()
            }else{
                (tabFour as? VCMypage)?.setMemberInfo(appInfo.getMemberInfo()!)
            }
        }
    }
    
    class MemberInfo2:ApiResult{
        let vcMain : VCMain
        init(_ vcMain : VCMain){
            self.vcMain = vcMain
        }
        func onResult(response: BaseResponse) {
            if let _ = response.request as? MemberInfoRequest{
                vcMain.appInfo.setMemberInfo(MemberInfoResponse(baseResponce: response))
                if let _ = vcMain.appInfo.getMemberInfo(){
                    (vcMain.tabFour as? VCMypage)?.setMemberInfo(vcMain.appInfo.getMemberInfo()!)
                }
            }
        }
        
        func onError(e: AFError, method: String) {
            
        }
    }
    
    fileprivate func startLogIn() -> Bool{
        let sb = UIStoryboard.init(name:"Login", bundle: nil)
        guard let mainvc = sb.instantiateViewController(withIdentifier: "loginvc") as? UINavigationController else {
            return false
        }
        
        mainvc.modalPresentationStyle = .fullScreen
        self.present(mainvc, animated: true);
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers!.index(of: viewController){
            
            if(!appInfo.getIsLogin()){
                if(index == 1 || index == 2){
                    if(self.startLogIn() == false){return false}
                    return false
                }
            }else{
                if(index == 2){
                    if(!self.KYC){
                        getAMLState()
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func getAMLState(){
        let request = GetKYCStateRequest()
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? GetKYCStateRequest{
            let data = GetKYCStateResponse(baseResponce: response)
            if let state = data.getState(){
                if(state == "401"){
                    
                    return
                }
                if(state == "200"){
                    if let aml = data.getAMLState(){
                        if(aml == "c"){
                            self.showErrorDialog("고객확인제도 인증이 요청되어 관리자의 승인 중입니다.")
                            return
                        }
                        if(aml == "N"){
                            DialogUtils().makeDialog(
                            uiVC: self,
                            title: "고객확인제도",
                            message:"고객확인 인증 절차를 완료한 후, 모든 거래서비스, 입출금 이용이 가능합니다.",
                            UIAlertAction(title: "고객확인제도 인증", style: .default) { (action) in
                                let sb = UIStoryboard.init(name:"Kyc", bundle: nil)
                                guard let mainvc = sb.instantiateViewController(withIdentifier: "kycnavivc") as? UINavigationController else {
                                    return
                                }
                                
                                mainvc.modalPresentationStyle = .fullScreen
                                self.present(mainvc, animated: true);
                            },
                            UIAlertAction(title: "다음에 하기", style: .destructive) { (action) in
                            })
                            return
                        }
                        if(aml == "cc"){
                            self.KYC = true
                            self.selectedIndex = 2
                            return
                        }
                    }
                    
                }
            }
        }
    }
    
    override func onError(e:AFError, method:String){
        
    }
    
    func goKYC(){
        let sb = UIStoryboard.init(name:"Kyc", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "kycnavivc") as? UINavigationController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
}
