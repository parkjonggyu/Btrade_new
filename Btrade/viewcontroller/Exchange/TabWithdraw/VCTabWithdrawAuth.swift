//
//  VCTabWithdrawAuth.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/19.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCTabWithdrawAuth:VCBase {
    var vcTabWithdraw:VCTabWithdraw?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goAuth(_ sender: Any) {
        let sb = UIStoryboard.init(name:"Mypage", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "otpregistervc") as? VCOtpRegister else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
}
