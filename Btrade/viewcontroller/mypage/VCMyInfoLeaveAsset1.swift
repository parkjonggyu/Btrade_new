//
//  VCMyInfoLeaveAsset1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/23.
//

import Foundation
import Alamofire

class VCMyInfoLeaveAsset1: VCBase {
    var totalAsset:String?
    
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var totalAssetText: UILabel!
    
    @IBOutlet weak var goAsset: UILabel!
    @IBOutlet weak var goFinance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(totalAsset == nil){
            stop()
            return
        }
        
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        goAsset.isUserInteractionEnabled = true
        goAsset.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        goFinance.isUserInteractionEnabled = true
        goFinance.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        
        totalAssetText.text = "회원님의 자산 평가금액은 " + totalAsset! + "KRW입니다."
    }
    
    @objc func clickedBtn(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            stop()
        }else if(sender.view == goAsset){
            if let vc = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController as? VCMain{
                vc.setNavData = "assetvc"
            }
            UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
        }else if(sender.view == goFinance){
            if let vc = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController as? VCMain{
                vc.setNavData = "financevc"
            }
            UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
        }
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedBack(_ sender: Any) {
        UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
    }
    
}
