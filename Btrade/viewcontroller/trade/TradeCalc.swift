//
//  TradeCalc.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/27.
//

import UIKit

class TradeCalc{
    
    let MaxSize:Double = 10
    
    func makeCandleImage(hogaSub:[String:Any],_ double_dif:Double, _ name:String,_ imageView:UIImageView){
        if(double_dif == 0 && (hogaSub["HIGH_PRICE_TODAY"] as? Double) ?? 0 == (hogaSub["LOW_PRICE_TODAY"] as? Double) ?? 0){
            noImage(imageView: imageView);
            return
        }
        
        var high_price = hogaSub["HIGH_PRICE_TODAY"] as? Double ?? 0
        var low_price = hogaSub["LOW_PRICE_TODAY"] as? Double ?? 0
        var bodyHigh_price = hogaSub["CLOSING_PRICE"] as? Double ?? 0
        var bodyLow_price = hogaSub["PRICE_NOW"] as? Double ?? 0
        var state = UIColor.gray
        
        if(double_dif > 0){
            state = UIColor.red
            bodyHigh_price = hogaSub["PRICE_NOW"] as? Double ?? 0
            bodyLow_price = hogaSub["CLOSING_PRICE"] as? Double ?? 0
        }else{
            state = UIColor.blue
            bodyHigh_price = hogaSub["CLOSING_PRICE"] as? Double ?? 0
            bodyLow_price = hogaSub["PRICE_NOW"] as? Double ?? 0
        }
        
        
        //차트 데이터를 이용하지 않기 때문에 보정작업
        if(high_price < bodyHigh_price){high_price = bodyHigh_price}
        if(high_price < bodyLow_price){high_price = bodyLow_price}
        
        if(low_price > bodyHigh_price){low_price = bodyHigh_price}
        if(low_price > bodyLow_price){low_price = bodyLow_price}
        
        
        // 최저값, 최고값을 이용한 퍼센트 수치
        var allPer:Double = (1 - (low_price / high_price)) * 100
        if(allPer > MaxSize){allPer = MaxSize}
        
        //전체 크기
        let allImageSize = high_price - low_price
        
        //전체 크기를 비율로 계산
        let rate = allPer / allImageSize
        
        //윗꼬리, 몸통, 아랫꼬리를 비율로계산
        let topImageSize = (high_price - bodyHigh_price) * rate
        let centerImageSize = (bodyHigh_price - bodyLow_price) * rate
        let bottomImageSize = (bodyLow_price - low_price) * rate
        
        //print("======================== : " , name)
        
        //makeImage(top: 9, body: 0, bottom: 1, state: state, imageView: imageView)
        
        makeImage(top: ((Float)(topImageSize)), body: ((Float)(centerImageSize)), bottom: ((Float)(bottomImageSize)), state: state, imageView: imageView)
    }
    
    fileprivate func noImage(imageView:UIImageView){
        makeImage(top: 0, body: 0, bottom: 0, state: .gray, imageView: imageView)
    }
    
    fileprivate func makeImage(top:Float, body:Float, bottom:Float, state:UIColor, imageView:UIImageView){
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        let width = Float(imageView.frame.size.width)
        let height = Float(imageView.frame.size.height)
        
        let rate = (height / Float(MaxSize))
        
        
        if(top == 0 && body == 0 && bottom == 0){
            //선굵기 설정
            context.setLineWidth(1)
            //선 칼라 설정
            context.setStrokeColor(state.cgColor)
            context.move(to: CGPoint(x:0, y:Int((height / 2))))
            context.addLine(to: CGPoint(x:Int((width)), y:Int((height / 2))))
            context.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return
        }
        
        
        var topLine = top
        if(state == UIColor.red){topLine = topLine + body}
        topLine = (height / 2) - ((topLine * rate) / 2)
            
        var bottomLine = bottom
        if(state == UIColor.blue){bottomLine = bottomLine + body}
        bottomLine = ((bottomLine * rate) / 2) + (height / 2)
        
        //선굵기 설정
        context.setLineWidth(1)
        //선 칼라 설정
        context.setStrokeColor(state.cgColor)
        //윗꼬리 , 아랫꼬리 그리기
        context.move(to: CGPoint(x:Int((width / 2)), y:Int(topLine)))
        context.addLine(to: CGPoint(x:Int((width / 2)), y:Int(bottomLine)))
        context.strokePath()
        
        //print("state : " , state)
        
        if(state == UIColor.gray){
            context.setLineWidth(1)
            context.setStrokeColor(state.cgColor)
            context.move(to: CGPoint(x:0, y:Int((height / 2))))
            context.addLine(to: CGPoint(x:Int((width)), y:Int((height / 2))))
            context.strokePath()
        }else{
            var tempBody = (body * rate) / 2
            var y = (height / 2)
            
            if(tempBody == 0){tempBody = 1}
            
            if(state == .red){
                y = y - (tempBody / 2)
            }else{
                y = y + (tempBody / 2)
            }
            
            //print("topLine : " , topLine)
            //print("bottomLine : " , bottomLine)
            //print("tempBody : " , tempBody)
            //print("y : " , y)
            
            context.setLineWidth(CGFloat(tempBody))
            context.setStrokeColor(state.cgColor)
            context.move(to: CGPoint(x:0, y:Int(y)))
            context.addLine(to: CGPoint(x:Int((width)), y:Int(y)))
            context.strokePath()
        }
       
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
   }
}
