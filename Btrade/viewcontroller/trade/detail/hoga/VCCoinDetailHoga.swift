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
        setHogaBuyData()
    }
    
    fileprivate func setHogaBuyData(){
        for idx in (1 ... HOGAMAX){
            
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
