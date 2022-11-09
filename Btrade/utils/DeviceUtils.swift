//
//  DeviceUtils.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/11/08.
//

import Foundation
import UIKit

class DeviceUtils{
    
    enum Device {
        case iPhone11
        case iPhone12
        case iPhone12Pro
        case iPhone8Plus
        case iPhone8
        case iPhoneMini, iPhoneXS
    }
    
    func getSizeByHeight() -> Device{
        let h = UIScreen.main.bounds.size.height
        if(h == 896){
            return Device.iPhone11
        }else if(h == 926){
            return Device.iPhone12
        }else if(h == 844){
            return Device.iPhone12Pro
        }else if(h == 736){
            return Device.iPhone8Plus
        }else if(h == 667){
            return Device.iPhone8
        }else {
            return Device.iPhoneMini
        }
    }
}
