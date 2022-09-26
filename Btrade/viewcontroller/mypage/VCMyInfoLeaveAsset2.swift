//
//  VCMyInfoLeaveAsset2.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/23.
//

import Foundation
import Alamofire

class VCMyInfoLeaveAsset2: VCBase {
    var totalAsset:String?
    
    @IBOutlet weak var totalAssetText: UILabel!
    @IBOutlet weak var goAssetBtn: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(totalAsset == nil){
            stop()
            return
        }
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        goAssetBtn.isUserInteractionEnabled = true
        goAssetBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedBtn)))
        
        totalAssetText.text = "회원님의 자산 평가금액은 " + totalAsset! + "KRW입니다."
    }
    
    
    @objc func clickedBtn(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            stop()
        }else if(sender.view == goAssetBtn){
            if let vc = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController as? VCMain{
                vc.setNavData = "assetvc"
            }
            UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
        }
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    @IBAction func goQuit(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "myinfoquitapplicationvc") as? VCMyinfoQuitApplication else {
            return
        }
        vc.totalAsset = totalAsset
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
}
