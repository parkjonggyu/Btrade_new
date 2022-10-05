//
//  TradeCompletePoupu.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/05.
//

import Foundation
import UIKit


class TradeCompletePopup:VCBase{
    var message:String?
    var timer: Timer? = nil
    
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var msgText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let msg = message{
            msgText.text = msg
        }
        
        viewLayout.layer.cornerRadius = 30
        viewLayout.layer.borderWidth = 2
        viewLayout.layer.borderColor = UIColor.systemGray2.cgColor
        
        startTimer()
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerMethod(){
        stop()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        stop()
    }
    
    fileprivate func stop(){
        stopTimer()
        self.dismiss(animated: true)
    }
}
