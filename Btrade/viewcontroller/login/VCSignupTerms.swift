//
//  VCSignupTerms.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/12.
//

import Foundation
import UIKit

class VCSignupTerms:VCBase{
    
    var terms1 = false,terms2 = false
    
    
    @IBOutlet weak var all_check: UIButton!
    @IBOutlet weak var terms1_check: UIButton!
    @IBOutlet weak var terms2_check: UIButton!
    @IBOutlet weak var terms1_text: UILabel!
    @IBOutlet weak var terms2_text: UILabel!
    @IBOutlet weak var terms1_go: UILabel!
    @IBOutlet weak var terms2_go: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        terms1_text.isUserInteractionEnabled = true
        terms1_text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
        terms2_text.isUserInteractionEnabled = true
        terms2_text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
        
        terms1_go.isUserInteractionEnabled = true
        terms1_go.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
        terms2_go.isUserInteractionEnabled = true
        terms2_go.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsText)))
        
        
    }
    
    @objc
    func goToTermsText(sender:UITapGestureRecognizer){
        if(sender.view == terms1_text || sender.view == terms1_go){
            terms1 = true
            viewTerms(terms1_text.text!, "1")
        }else if(sender.view == terms2_text || sender.view == terms2_go){
            terms2 = true
            viewTerms(terms2_text.text!, "2")
        }
    }
    
    func viewTerms(_ title:String,_ detail:String){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "signuptextvc") as? VCSignupText
        pushVC?.TITLE = title
        pushVC?.DETAIL = detail
        self.navigationController?.pushViewController(pushVC!, animated: true)
        setAllTerms()
    }
    
    @IBAction func allCheck(_ sender: Any) {
        if terms1 && terms2{
            terms1 = false
            terms2 = false
        }else{
            terms1 = true
            terms2 = true
        }
        setAllTerms();
    }
    
    @IBAction func termsChecked(_ sender: UIButton) {
        if(sender == terms1_check){
            terms1 = !terms1
        }else if(sender == terms2_check){
            terms2 = !terms2
        }
        setAllTerms()
    }
    
    
    func setAllTerms(){
        setImageTerms(terms1, terms1_check)
        setImageTerms(terms2, terms2_check)
        if terms1 && terms2 {
            setImageTerms(true, all_check)
        }else{
            setImageTerms(false, all_check)
        }
    }
    
    func setImageTerms(_ terms:Bool, _ btn:UIButton){
        if(terms){
            btn.setImage(UIImage(named: "check_active.png") , for: .normal)
        }else{
            btn.setImage(UIImage(named: "check_inactive.png") , for: .normal)
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is VCLogin {
                _ = self.navigationController?.popToViewController(vc as! VCLogin, animated: true)
                return
            }
        }
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func goToSignup(_ sender: Any) {
        if terms1 && terms2 {
            
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "signupvc")
            self.navigationController?.pushViewController(pushVC!, animated: true)
            return
        }
        DialogUtils().makeDialog(
            uiVC: self,
            title: "알림",
            message:"이용약관에 동의해 주세요!")
    }
}
