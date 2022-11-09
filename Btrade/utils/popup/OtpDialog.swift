//
//  OtpDialog.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/22.
//

import Foundation
import UIKit

class OtpDialog: UIViewController{
    
    @IBOutlet weak var popupLayout: UIView!
    @IBOutlet weak var okLayout: UIView!
    @IBOutlet weak var backLayout: UIView!
    @IBOutlet weak var okBtn: UILabel!
    @IBOutlet weak var backBtn: UILabel!
    @IBOutlet weak var otpEdit: UITextField!
    var delegate:((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }
    
    fileprivate func initLayout(){
        popupLayout.layer.cornerRadius = 20
        okLayout.layer.cornerRadius = 10
        backLayout.layer.cornerRadius = 10
        
        okBtn.isUserInteractionEnabled = true
        okBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
        otpEdit.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        otpEdit.delegate = self
        otpEdit.background = UIImage(named: "text_field_inactive.png")
    }
    
    @objc func onClickEvent(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            stop()
        }else if(sender.view == okBtn){
            if otpEdit.text?.count != 6{
                showToast("OTP 6자리를 입력해 주세요.")
                return
            }
            if let d = delegate{
                d(otpEdit.text!)
            }
            stop()
        }
    }
    
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == otpEdit){
            let scale = 6
            guard let _ = Decimal(string:otpEdit.text!) else {
                otpEdit.text = ""
                return
            }
            let temp = otpEdit.text?.components(separatedBy: ".")
            if(temp?.count ?? 2 > 1){
                otpEdit.text = ""
                return
            }
            
            if otpEdit.text?.count ?? 0 > 6{
                otpEdit.text = (otpEdit.text?.substring(from: 0, to: scale) ?? "")
            }
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    func showToast(_ message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.5, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}


extension OtpDialog: UITextFieldDelegate {
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let _ = textField.restorationIdentifier{
            textField.background = UIImage(named: "text_field_active.png")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _ = textField.restorationIdentifier{
            textField.background = UIImage(named: "text_field_inactive.png")
        }
    }
}
