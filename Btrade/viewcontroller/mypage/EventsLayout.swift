//
//  CustomView.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/05.
//

import UIKit

class EventsLayout: UIView, UIGestureRecognizerDelegate {
    var superView:UIViewController!
    init(_ superView:UIViewController, frame: CGRect,_ idx:Int) {
        super.init(frame: frame)
        self.superView = superView
        
        nosignedView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK - Events
    fileprivate func nosignedView(){
        let nib = UINib(nibName: "EventsLayout", bundle: Bundle.main)
        guard let xibView = nib.instantiate(withOwner: self, options: nil)[1] as? UIView else { return }
        
        self.addSubview(xibView)
        noSignedInit()
    }
    
    
    @IBOutlet var aaa: UIView!
    @IBOutlet weak var signupText: UILabel!
    @IBOutlet weak var loginText: UILabel!
    fileprivate func noSignedInit (){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        loginText.addGestureRecognizer(tapGestureRecognizer)
        signupText.addGestureRecognizer(tapGestureRecognizer)
        aaa.addGestureRecognizer(tapGestureRecognizer)
        
        loginText.isUserInteractionEnabled = true
        signupText.isUserInteractionEnabled = true
        aaa.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("view tapped")
    }
    
    @objc func goToLogIn(sender:UITapGestureRecognizer){
        print("123123901820398190")
        if(sender.view == loginText){
            let sb = UIStoryboard.init(name:"Login", bundle: nil)
            guard let mainvc = sb.instantiateViewController(withIdentifier: "loginvc") as? UINavigationController else {
                return
            }
            mainvc.modalPresentationStyle = .fullScreen
            superView.present(mainvc, animated: true);
        }else if(sender.view == signupText){
            let sb = UIStoryboard.init(name:"Login", bundle: nil)
            guard let mainvc = sb.instantiateViewController(withIdentifier: "signupvc") as? UINavigationController else {
                return
            }
            mainvc.modalPresentationStyle = .fullScreen
            superView.present(mainvc, animated: true);
        }
    }
    
}
