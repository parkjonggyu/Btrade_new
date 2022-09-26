//
//  VCKycCom.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/03.
//

import Foundation
import UIKit

class VCKycCom: VCBase{
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        if let _ = appInfo.memberInfo{
            appInfo.memberInfo?.update = true
        }
        UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
    }
}
