//
//  VCKyc1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/21.
//

import Foundation
import UIKit

class VCKyc1: VCBase, WebResult {
    
    @IBOutlet weak var mInsertBtn: UIButton!
    var UUID:String?
    var name:String?
    var birthday:String?
    var phone:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UUID == nil){
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if(UUID == nil){
            startPhoneAuth()
        }
    }
    
    fileprivate func startPhoneAuth() {
        let sb = UIStoryboard.init(name:"Webview", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "webvc") as? VCWeb else {
            return
        }
        vc.page = BuildConfig.SERVER_URL + "m/kycauth/kycAuth.do?os=ANDROID"
        vc.smsDelegate = self
        vc.titleString = "비트레이드 - 휴대전화 본인인증" 
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
    func result(_ map: Dictionary<String, Any>) {
        phone = map["phone_no"] as? String
        UUID = map["uuid"] as? String
        name = map["full_name"] as? String
        birthday = map["birthday"] as? String
        nextStep()
    }
    
    fileprivate func nextStep() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "kyc2vc") as! VCKyc2
        vc.name = name!
        vc.phoneNum = phone!
        vc.birthday = birthday?.substring(from: birthday!.index(birthday!.startIndex, offsetBy: 2))
        vc.birthdayAll = birthday
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


