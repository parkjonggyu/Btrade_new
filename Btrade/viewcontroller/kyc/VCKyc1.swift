//
//  VCKyc1.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/21.
//

import Foundation
import UIKit

class VCKyc1: VCBase, WebResult {
    
    
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var mPhoneText: UITextField!
    
    @IBOutlet weak var mInsertBtn: UIButton!
    var UUID:String?
    var name:String?
    var birthday:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UUID == nil){
            subTitle.layer.isHidden = true
            mPhoneText.layer.isHidden = true
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if(UUID == nil){
            startPhoneAuth()
        }else{
            nextStep()
        }
    }
    
    fileprivate func startPhoneAuth() {
        let sb = UIStoryboard.init(name:"Webview", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "webvc") as? VCWeb else {
            return
        }
        vc.page = BuildConfig.SERVER_URL + "m/kycauth/kycAuth.do?os=ANDROID"
        vc.smsDelegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
    func result(_ map: Dictionary<String, Any>) {
        subTitle.layer.isHidden = false
        mPhoneText.layer.isHidden = false
        mPhoneText.text = map["phone_no"] as? String
        UUID = map["uuid"] as? String
        name = map["full_name"] as? String
        birthday = map["birthday"] as? String
        mInsertBtn.setTitle("다음단계", for: .normal)
    }
    
    fileprivate func nextStep() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "kyc2vc") as! VCKyc2
        vc.name = name!
        vc.phoneNum = mPhoneText.text!
        vc.birthday = birthday?.substring(from: birthday!.index(birthday!.startIndex, offsetBy: 2))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


