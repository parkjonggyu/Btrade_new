//
//  VCSplash.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/06/30.
//

import Foundation
import UIKit
import Network
import Alamofire

class VCSplash: VCBase, FirebaseInterface {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thread = MainLoop(self)
        thread.start()
    }
    
    // MARK: - init1
    class MainLoop:Thread{
        let vcSplash : VCSplash
        init(_ splash : VCSplash){
            self.vcSplash = splash
        }
        override func main() {
            init1()
        }
        
        func init1(){
            vcSplash.init1()
        }
    }
    
    fileprivate func init1(){
        
        versionCheckStart()
    }
    
   
    
    func versionCheckStart(){
        ApiFactory(apiResult: VersionCheck(self), request: VersionCheckRequest()).newThread()
    }
    
    class VersionCheck:ApiResult{
        let vcSplash : VCSplash
        init(_ splash : VCSplash){
            self.vcSplash = splash
        }
        func onResult(response: BaseResponse) {
            
            let data = VersionCheckResponse(baseResponce: response)
            if(data.isSuccess()){
                if(data.isNewVersion()){
                    vcSplash.showUpdateDialog(data.isRequireUpdate());
                }else{
                    vcSplash.init2()
                }
            }else{
                vcSplash.showErrorDialog()
            }
        }
        
        func onError(e: AFError, method: String) {
            vcSplash.showErrorDialog()
        }
    }
    
    func showUpdateDialog(_ isRequire:Bool){
        DispatchQueue.main.async{
            let appId : String = BuildConfig.STORE_ID;
            if isRequire {
                DialogUtils().makeDialog(
                    uiVC: self,
                    title: "업데이트",
                    message:"새로운 업데이트가 있습니다. 최신 버전으로 업데이트 해 주세요",
                    UIAlertAction(title: "업데이트", style: .default) { (action) in
                        self.openAppStore(appId)
                    })
            }else {
                DialogUtils().makeDialog(
                uiVC: self,
                title: "업데이트",
                message:"새로운 업데이트가 있습니다. 최신 버전으로 업데이트 하시겠습니까?",
                UIAlertAction(title: "업데이트", style: .default) { (action) in
                    self.openAppStore(appId)
                },
                UIAlertAction(title: "다음에 하기", style: .destructive) { (action) in
                    self.init2();
                })
            }
        }
    }
    
    var openAppStore = {(appId: String) in
        let url = "itms-apps://itunes.apple.com/app/" + appId;
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // MARK: - init2
    func init2(){
        getCoinList()
    }
    
    func getCoinList(){
        ApiFactory(apiResult: CoinList(self), request: MarketListRequest()).newThread()
    }
    
    class CoinList:ApiResult{
        let vcSplash : VCSplash
        init(_ splash : VCSplash){
            self.vcSplash = splash
        }
        func onResult(response: BaseResponse) {
            let data = MarketListResponse(baseResponce: response)
            let coins : Array<MarketListResponse.Coin> = data.getData()
            vcSplash.appInfo.setCoinList(array: coins)
            FirebaseDatabaseHelper.getInstance().onHogaBTC(vcSplash, vcSplash.appInfo.getCoinList())
        }
        
        func onError(e: AFError, method: String) {
            FirebaseDatabaseHelper.getInstance().removeObserve()
            vcSplash.showErrorDialog()
        }
    }
    
    
    // MARK: - FirebaseInterface
    func onDataChange(market: String) {
        FirebaseDatabaseHelper.getInstance().removeObserve()
        if(market == "ALL"){
            if let allhoga = APPInfo.getInstance().allFirebaseHoga {
                var array = appInfo.getCoinList()
                var remove = [Int]()
                var i = 0;
                for coin in array{
                    if let hoga = allhoga.data[coin.coin_code]{
                        coin.firebaseHoga = FirebaseHoga(hoga as! NSDictionary)
                    }else{
                        remove.append(i)
                    }
                    i += 1
                }
                
                i = 0
                for index in remove{
                    array.remove(at: index - i)
                    i += 1
                }
                FirebaseDatabaseHelper.getInstance().removeObserve()
                init3()
            }
        }else{
            showErrorDialog();
        }
    }
 
    
    // MARK: - init3()
    func init3(){
        goMain()
    }
    
    func goMain(){
        let sb = UIStoryboard.init(name:"MainTab", bundle: nil)
        guard let mainvc = sb.instantiateViewController(withIdentifier: "maintab") as? UIViewController else {
            showErrorDialog();
            return
        }
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else{
            showErrorDialog();
            return
        }
        delegate.window?.rootViewController = mainvc
    }
}



