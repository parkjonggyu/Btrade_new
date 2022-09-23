//
//  AuthTimer.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/13.
//

import Foundation
import UIKit

class AuthTimer{
    var millisInFuture:Int64;
    let countDownInterval:Int64 = 1000;
    var authTimerInterface:AuthTimerInterface;
    var mTimerText:UILabel;
    
    var timer: Timer? = nil
    
    var tick:Int64 = 0
    init(_ millisInFuture:Int64, _ authTimerInterface:AuthTimerInterface, _ mTimerText:UILabel){
        self.millisInFuture = millisInFuture
        self.authTimerInterface = authTimerInterface
        self.mTimerText = mTimerText
        
        
    }
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
    }
    
    func stop(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    func timerMethod(){
        tick += 1
        let amount = millisInFuture - (countDownInterval * tick)
        let min = amount / 60000
        var sec = amount % 60000
        
        if(amount < 0){
            stop()
            mTimerText.text = "00:00"
            authTimerInterface.endTimer()
            return
        }
        
        sec = sec / 1000
        
        var MIN:String = String(min)
        var SEC:String = String(sec)
        
        if MIN.count == 1{MIN = "0" + MIN}
        if SEC.count == 1{SEC = "0" + SEC}
        
        let time = MIN + ":" + SEC
        mTimerText.text = time
    }
}
