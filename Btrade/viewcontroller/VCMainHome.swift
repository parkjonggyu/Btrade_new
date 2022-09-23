//
//  VBMainHome.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/07.
//

import UIKit

class VCMainHome: VCBase {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnTrade: UIButton!
    @IBOutlet weak var btnAsset: UIButton!
    @IBOutlet weak var btnFinance: UIButton!
    @IBOutlet weak var btnMypage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let sbOne = UIStoryboard.init(name:"Trade", bundle: nil)
        guard let tabOne = sbOne.instantiateViewController(withIdentifier: "tradevc") as? UIView else {
            return
        }
        mainView.addSubview(tabOne)
    }
    

    
    // MARK: - Navigation

     
    @IBAction func btnClick(_ sender: UIButton) {
        print(sender)
    }
}
