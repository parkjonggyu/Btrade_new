//
//  VCCoinDetailhoga.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/06.
//


import Alamofire
import UIKit
import FirebaseDatabase

class VCCoinDetailHoga:VCBase{
    var vcDetail:VCCoinDetail?
    
    @IBOutlet var sellPriceText: [UILabel]!
    @IBOutlet var sellPriceKrwText: [UILabel]!
    @IBOutlet var sellVolumeText: [UILabel]!
    @IBOutlet var sellVolumeBar: [NSLayoutConstraint]!
    
    @IBOutlet var buyPriceText: [UILabel]!
    @IBOutlet var buyPriceKrwText: [UILabel]!
    @IBOutlet var buyVolumeText: [UILabel]!
    @IBOutlet var buyVolumeBar: [NSLayoutConstraint]!
    
    
    
    let HOGAMAX = 10
    var mArrayHogyBuy:Array<[String:Any?]?> = Array<[String:Any?]?>()
    var mArrayHogySell:Array<[String:Any?]?> = Array<[String:Any?]?>()
    var mAmountBuy:Double = 0
    var mAmountSell:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vcDetail?.setInterface(self)
        setAllLayout()
    }
    
    fileprivate func setAllLayout(){
        
    }
}

//MARK: - Firebase
extension VCCoinDetailHoga: FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        setAllLayout();
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        setAllLayout()
    }
}



//MARK: - hogaLayout
extension VCCoinDetailHoga{
    fileprivate func hogaLayou(){
        initHogaBuyData()
        initHogaSellData()
        hogaBuyData()
        hogaSellData()
    }
    
    fileprivate func hogaBuyData(){
        for idx in (0 ..< HOGAMAX){
            let hoga = mArrayHogyBuy[idx]
            
            let price = DoubleDecimalUtils.newInstance(hoga?["price"] as? String)
            let amount = DoubleDecimalUtils.newInstance(hoga?["amount"] as? String)
                
            let krwPrice = Int(DoubleDecimalUtils.mul(price , appInfo.krwValue!))
            
            buyPriceKrwText[idx].text = CoinUtils.currency(krwPrice) + "KRW"
            buyPriceText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: price).doubleValue)
            buyVolumeText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: amount).doubleValue)
            
            var per = DoubleDecimalUtils.div(amount, DoubleDecimalUtils.newInstance(mAmountBuy)) / 100
            
            let volumeAllSize = buyPriceText[idx].frame.size.width
            if(per < 0.03){per = 0.03}
            if(per > 1){per = 1}
            var size = volumeAllSize * per
            if(size < 1){size = 1}
            
            
            buyVolumeBar[idx].constant = size
        }
    }
    
    fileprivate func hogaSellData(){
        for idx in (0 ..< HOGAMAX){
            let hoga = mArrayHogySell[idx]
            
            let price = DoubleDecimalUtils.newInstance(hoga?["price"] as? String)
            let amount = DoubleDecimalUtils.newInstance(hoga?["amount"] as? String)
                
            let krwPrice = Int(DoubleDecimalUtils.mul(price , appInfo.krwValue!))
            
            sellPriceKrwText[idx].text = CoinUtils.currency(krwPrice) + "KRW"
            sellPriceText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: price).doubleValue)
            sellVolumeText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: amount).doubleValue)
            
            var per = DoubleDecimalUtils.div(amount, DoubleDecimalUtils.newInstance(mAmountSell)) / 100
            
            let volumeAllSize = sellPriceText[idx].frame.size.width
            if(per < 0.03){per = 0.03}
            if(per > 1){per = 1}
            var size = volumeAllSize  * per
            if(size < 1){size = 1}
            
            
            sellVolumeBar[idx].constant = size
        }
    }
    
    fileprivate func initHogaBuyData(){
        mArrayHogyBuy.removeAll();
        mAmountBuy = 0
        for idx in (1 ... HOGAMAX){
            guard let hoga = appInfo.getFirebaseHoga()?.getHOGA(VCCoinDetail.coin?.coin_code ?? "") else{
                mArrayHogyBuy.append(nil)
                continue
            }
            var buy = [String:Any?]()
            if let price = hoga["hoga_buy_" + String(idx)]{
                buy["price"] = price
            }else{
                buy["price"] = nil
            }
            if let amount = hoga["hoga_buy_amount_" + String(idx)]{
                buy["amount"] = amount
                let a = NSDecimalNumber(decimal: DoubleDecimalUtils.newInstance(amount as? String)).doubleValue
                mAmountBuy = mAmountBuy + a
            }else{
                buy["amount"] = nil
            }
            mArrayHogyBuy.append(buy)
        }
        
    }
    
    fileprivate func initHogaSellData(){
        mArrayHogySell.removeAll();
        mAmountSell = 0
        for idx in (1 ... HOGAMAX).reversed(){
            guard let hoga = appInfo.getFirebaseHoga()?.getHOGA(VCCoinDetail.coin?.coin_code ?? "")  else{
                mArrayHogySell.append(nil)
                continue
            }
            var sell = [String:Any?]()
            if let price = hoga["hoga_sell_" + String(idx)]{
                sell["price"] = price
            }else{
                sell["price"] = nil
            }
            if let amount = hoga["hoga_sell_amount_" + String(idx)]{
                sell["amount"] = amount
                let a = NSDecimalNumber(decimal: DoubleDecimalUtils.newInstance(amount as? String)).doubleValue
                mAmountSell = mAmountSell + a
            }else{
                sell["amount"] = nil
            }
            mArrayHogySell.append(sell)
        }
        
    }
}
