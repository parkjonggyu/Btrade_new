//
//  PopupBank.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/11/05.
//

import Foundation
import UIKit

class PopupBank:UIViewController{
    var delegate:((KycVo.SMAP) -> Void)?
    
    
    @IBOutlet weak var popupLayout: UIView!
    @IBOutlet weak var backBtn: UIImageView!
    
    @IBOutlet weak var select1_1: UIStackView!
    @IBOutlet weak var select2_1: UIStackView!
    @IBOutlet weak var select3_1: UIStackView!
    @IBOutlet weak var select4_1: UIStackView!
    @IBOutlet weak var select5_1: UIStackView!
    @IBOutlet weak var select6_1: UIStackView!
    @IBOutlet weak var select7_1: UIStackView!
    @IBOutlet weak var select8_1: UIStackView!
    @IBOutlet weak var select9_1: UIStackView!
    @IBOutlet weak var select10_1: UIStackView!
    @IBOutlet weak var select11_1: UIStackView!
    @IBOutlet weak var select12_1: UIStackView!
    
    @IBOutlet weak var select1_2: UIStackView!
    @IBOutlet weak var select2_2: UIStackView!
    @IBOutlet weak var select3_2: UIStackView!
    @IBOutlet weak var select4_2: UIStackView!
    @IBOutlet weak var select5_2: UIStackView!
    @IBOutlet weak var select6_2: UIStackView!
    @IBOutlet weak var select7_2: UIStackView!
    @IBOutlet weak var select8_2: UIStackView!
    @IBOutlet weak var select9_2: UIStackView!
    @IBOutlet weak var select10_2: UIStackView!
    @IBOutlet weak var select11_2: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    fileprivate func setLayout(){
        popupLayout.clipsToBounds = true
        popupLayout.layer.cornerRadius = 30
        popupLayout.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        
        
        select1_1.isUserInteractionEnabled = true
        select2_1.isUserInteractionEnabled = true
        select3_1.isUserInteractionEnabled = true
        select4_1.isUserInteractionEnabled = true
        select5_1.isUserInteractionEnabled = true
        select6_1.isUserInteractionEnabled = true
        select7_1.isUserInteractionEnabled = true
        select8_1.isUserInteractionEnabled = true
        select9_1.isUserInteractionEnabled = true
        select10_1.isUserInteractionEnabled = true
        select11_1.isUserInteractionEnabled = true
        select12_1.isUserInteractionEnabled = true
        select1_2.isUserInteractionEnabled = true
        select2_2.isUserInteractionEnabled = true
        select3_2.isUserInteractionEnabled = true
        select4_2.isUserInteractionEnabled = true
        select5_2.isUserInteractionEnabled = true
        select6_2.isUserInteractionEnabled = true
        select7_2.isUserInteractionEnabled = true
        select8_2.isUserInteractionEnabled = true
        select9_2.isUserInteractionEnabled = true
        select10_2.isUserInteractionEnabled = true
        select11_2.isUserInteractionEnabled = true
        
        select1_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select2_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select3_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select4_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select5_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select6_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select7_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select8_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select9_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select10_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select11_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select12_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select1_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select2_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select3_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select4_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select5_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select6_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select7_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select8_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select9_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select10_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
        select11_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedBank)))
    }
    
    @objc func selectedTab(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            self.dismiss(animated: true)
        }
    }
    
    @objc func selectedBank(sender:UITapGestureRecognizer){
        if(sender.view == select1_1){
            didSelect("국민","004")
        }
        if(sender.view == select2_1){
            didSelect("하나","005")
        }
        if(sender.view == select3_1){
            didSelect("기업","003")
        }
        if(sender.view == select4_1){
            didSelect("SC제일","023")
        }
        if(sender.view == select5_1){
            didSelect("카카오뱅크","090")
        }
        if(sender.view == select6_1){
            didSelect("산업","002")
        }
        if(sender.view == select7_1){
            didSelect("수협","007")
        }
        if(sender.view == select8_1){
            didSelect("대구","031")
        }
        if(sender.view == select9_1){
            didSelect("광주","034")
        }
        if(sender.view == select10_1){
            didSelect("전북","037")
        }
        if(sender.view == select11_1){
            didSelect("새마을금고","045")
        }
        if(sender.view == select12_1){
            didSelect("우체국","071")
        }
        if(sender.view == select1_2){
            didSelect("신한","088")
        }
        if(sender.view == select2_2){
            didSelect("우리","020")
        }
        if(sender.view == select3_2){
            didSelect("농협","010")
        }
        if(sender.view == select4_2){
            didSelect("케이뱅크","089")
        }
        if(sender.view == select5_2){
            didSelect("토스뱅크","092")
        }
        if(sender.view == select6_2){
            didSelect("외환","081")
        }
        if(sender.view == select7_2){
            didSelect("한국씨티","027")
        }
        if(sender.view == select8_2){
            didSelect("부산","032")
        }
        if(sender.view == select9_2){
            didSelect("제주","035")
        }
        if(sender.view == select10_2){
            didSelect("경남","039")
        }
        if(sender.view == select11_2){
            didSelect("신협","048")
        }
    }
    
    fileprivate func didSelect(_ key:String, _ value:String){
        if let d = delegate{
            d(KycVo.SMAP(key: key, value: value))
        }
        self.dismiss(animated: true)
        print("value : " , value)
        print("key : " , key)
    }
}
