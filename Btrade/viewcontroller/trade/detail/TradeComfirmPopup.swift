//
//  TradeComfirmPopup.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/04.
//

import Foundation
import UIKit

class TradeComfirmPopup:VCBase{
    var trd_type:String?
    var coinCode:String?
    var coinKrName:String?
    var marketType:String?
    var volume:String?
    var price:String?
    var fee:String?
    var totalPrice:String?
    var nextStep:(() -> Void)?
    
    
    @IBOutlet weak var popupLayout: UIView!
    @IBOutlet weak var typeTitleText: UILabel!
    @IBOutlet weak var typeVolumeText: UILabel!
    @IBOutlet weak var typePriceText: UILabel!
    @IBOutlet weak var typeTotalPriceText: UILabel!
    @IBOutlet weak var typeConfirmText: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var typeCoinCodeText: UILabel!
    @IBOutlet weak var typeMarketTypeText1: UILabel!
    @IBOutlet weak var typeMarketTypeText2: UILabel!
    @IBOutlet weak var typeMarketTypeText3: UILabel!
    
    @IBOutlet weak var coinNameText: UILabel!
    @IBOutlet weak var coinVolumeText: UILabel!
    @IBOutlet weak var coinPriceText: UILabel!
    @IBOutlet weak var coinFeeText: UILabel!
    @IBOutlet weak var coinTotalPriceText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(trd_type == nil || coinCode == nil || coinKrName == nil || marketType == nil || volume == nil || price == nil || fee == nil || totalPrice == nil || nextStep == nil){
            stop()
            return
        }
        
        popupLayout.clipsToBounds = true
        popupLayout.layer.cornerRadius = 30
        popupLayout.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        makeLayout()
        setData()
    }
    
    fileprivate func setData(){
        coinNameText.text = coinKrName! + "(" + coinCode! + "/" + marketType! + ")"
        coinVolumeText.text = volume
        coinPriceText.text = price
        coinFeeText.text = fee
        coinTotalPriceText.text = totalPrice
    }
    
    fileprivate func makeLayout(){
        if trd_type! == "B"{
            typeTitleText.text = "매수 주문확인"
            typeVolumeText.text = "매수 수량"
            typePriceText.text = "매수 가격"
            typeTotalPriceText.text = "총 매수 가격"
            typeConfirmText.text = "위 내용으로 매수하시겠습니까?"
            nextBtn.setTitle("매수", for: .normal)
            nextBtn.setBackgroundImage(UIImage(named: "btn_back_red"), for: .normal)
        }else{
            typeTitleText.text = "매도 주문확인"
            typeVolumeText.text = "매도 수량"
            typePriceText.text = "매도 가격"
            typeTotalPriceText.text = "총 매도 가격"
            typeConfirmText.text = "위 내용으로 매도하시겠습니까?"
            nextBtn.setTitle("매도", for: .normal)
            nextBtn.setBackgroundImage(UIImage(named: "btn_back_blue"), for: .normal)
        }
        typeCoinCodeText.text = coinCode
        typeMarketTypeText1.text = marketType
        typeMarketTypeText2.text = marketType
        typeMarketTypeText3.text = marketType
    }
    
    @IBAction func goBackClicked(_ sender: Any) {
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    @IBAction func goNext(_ sender: Any) {
        self.dismiss(animated: true){
            if let c = self.nextStep{
                c()
            }
        }
    }
    
    
}
