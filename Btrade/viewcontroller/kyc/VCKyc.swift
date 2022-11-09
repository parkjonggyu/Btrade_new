//
//  VCKyc.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/21.
//

import Foundation
import UIKit

class VCKyc: VCBase {

    var terms1 = false,terms2 = false
    
    @IBOutlet weak var allCheck: UIButton!
    @IBOutlet weak var terms1Check: UIButton!
    @IBOutlet weak var terms2Check: UIButton!
    
    @IBOutlet weak var allText: UILabel!
    @IBOutlet weak var terms1Text: UILabel!
    @IBOutlet weak var terms2Text: UILabel!
    
    @IBOutlet weak var terms1go: UILabel!
    @IBOutlet weak var terms2go: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        terms1Text.isUserInteractionEnabled = true
        terms1Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
        terms2Text.isUserInteractionEnabled = true
        terms2Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
        terms1go.isUserInteractionEnabled = true
        terms1go.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
        terms2go.isUserInteractionEnabled = true
        terms2go.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
        
        allText.isUserInteractionEnabled = true
        allText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    
    @IBAction func checkClicked(_ sender: UIButton) {
        if sender == allCheck{
            if terms1 && terms2{
                terms1 = false
                terms2 = false
            }else{
                terms1 = true
                terms2 = true
            }
            setAllTerms()
        }else if sender == terms1Check{
            terms1 = !terms1
            setAllTerms()
        }else if sender == terms2Check{
            terms2 = !terms2
            setAllTerms()
        }
    }
    
    @objc
    func goToTermsText(sender:UITapGestureRecognizer){
        if(sender.view == allText){
            if terms1 && terms2{
                terms1 = false
                terms2 = false
            }else{
                terms1 = true
                terms2 = true
            }
            setAllTerms()
        }else if(sender.view == terms1Text || sender.view == terms1go){
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kycagree1_1vc")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }else if(sender.view == terms2Text || sender.view == terms2go){
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "kycagree1_2vc")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
    
    fileprivate func setAllTerms(){
        setImageTerms(terms1, terms1Check)
        setImageTerms(terms2, terms2Check)
        if terms1 && terms2 {
            setImageTerms(true, allCheck)
        }else{
            setImageTerms(false, allCheck)
        }
    }
    fileprivate func setImageTerms(_ terms:Bool, _ btn:UIButton){
        if(terms){
            btn.setImage(UIImage(named: "check_active.png") , for: .normal)
        }else{
            btn.setImage(UIImage(named: "check_inactive.png") , for: .normal)
        }
    }
    
    
    @IBAction func goNext(_ sender: Any) {
        if !terms1 || !terms2{
            showErrorDialog("약관에 동의해 주세요!")
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "kyc1vc") as! VCKyc1

        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "kyc4vc") as! VCKyc4

//        vc.mKyc["krName"] = "박종규"
//        vc.phoneNum = "01036614023"
//        vc.birthday = "810526"
//        vc.birthdayAll = "19810526"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
