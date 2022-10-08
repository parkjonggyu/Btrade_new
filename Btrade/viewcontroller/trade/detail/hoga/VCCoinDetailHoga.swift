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
    @IBOutlet weak var sellAllVolumText: UILabel!
    
    @IBOutlet var buyPriceText: [UILabel]!
    @IBOutlet var buyPriceKrwText: [UILabel]!
    @IBOutlet var buyVolumeText: [UILabel]!
    @IBOutlet var buyVolumeBar: [NSLayoutConstraint]!
    @IBOutlet weak var buyAllVolumText: UILabel!
    
    @IBOutlet var contractPriceText: [UILabel]!
    @IBOutlet var contractAmountText: [UILabel]!
    
    
    @IBOutlet weak var infoPriceText1: UILabel!
    @IBOutlet weak var infoMarketText: UILabel!
    @IBOutlet weak var infoPriceText2: UILabel!
    @IBOutlet weak var infoCoinText: UILabel!
    @IBOutlet weak var infoPriceText3: UILabel!
    @IBOutlet weak var infoPriceText4: UILabel!
    @IBOutlet weak var infoPriceText5: UILabel!
    @IBOutlet weak var infoPriceText5_2: UILabel!
    @IBOutlet weak var infoPriceText6: UILabel!
    @IBOutlet weak var infoPriceText7: UILabel!
    @IBOutlet weak var infoPriceText8: UILabel!
    @IBOutlet weak var infoPriceText9: UILabel!
    
    
    
    
    let HOGAMAX = 10
    var mArrayContract:Array<[String:Any?]?> = Array<[String:Any?]?>()
    var closingPrice:Double = 0
    
    var mArrayHogyBuy:Array<[String:Any?]?> = Array<[String:Any?]?>()
    var mArrayHogySell:Array<[String:Any?]?> = Array<[String:Any?]?>()
    var mAmountBuy:Double = 0
    var mAmountSell:Double = 0
    var mAmountMaxBuy:Double = 0
    var mAmountMaxSell:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAllLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vcDetail?.setInterface(self)
        setAllLayout()
    }
    
    fileprivate func setAllLayout(){
        hogaLayout()
        contractLayout()
        infoLayout()
    }
}

//MARK: - Firebase
extension VCCoinDetailHoga: FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        setAllLayout()
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        setAllLayout()
    }
}



//MARK: - hogaLayout
extension VCCoinDetailHoga{
    fileprivate func hogaLayout(){
        initHogaBuyData()
        initHogaSellData()
        hogaBuyData()
        hogaSellData()
    }
    
    fileprivate func hogaBuyData(){
        buyAllVolumText.text = DoubleDecimalUtils.removeLastZero(String(format: "%.8f", mAmountBuy))
        for idx in (0 ..< HOGAMAX){
            let hoga = mArrayHogyBuy[idx]
            
            let price = DoubleDecimalUtils.newInstance(hoga?["price"] as? String)
            let amount = DoubleDecimalUtils.newInstance(hoga?["amount"] as? String)
                
            let krwPrice = Int(DoubleDecimalUtils.mul(price , appInfo.krwValue!))
            
            buyPriceKrwText[idx].text = CoinUtils.currency(krwPrice) + "KRW"
            buyPriceText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: price).doubleValue)
            buyVolumeText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: amount).doubleValue)
            
            var per = DoubleDecimalUtils.div(amount, DoubleDecimalUtils.newInstance(mAmountMaxBuy)) / 100
            
            let volumeAllSize = self.view.frame.size.width / 3.0
            if(per < 0.03){per = 0.03}
            if(per > 1){per = 1}
            var size = volumeAllSize * per
            if(size < 1){size = 1}
            
            
            buyVolumeBar[idx].constant = size
        }
    }
    
    fileprivate func hogaSellData(){
        sellAllVolumText.text = DoubleDecimalUtils.removeLastZero(String(format: "%.8f", mAmountSell))
        for idx in (0 ..< HOGAMAX){
            let hoga = mArrayHogySell[idx]
            
            let price = DoubleDecimalUtils.newInstance(hoga?["price"] as? String)
            let amount = DoubleDecimalUtils.newInstance(hoga?["amount"] as? String)
                
            let krwPrice = Int(DoubleDecimalUtils.mul(price , appInfo.krwValue!))
            
            sellPriceKrwText[idx].text = CoinUtils.currency(krwPrice) + "KRW"
            sellPriceText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: price).doubleValue)
            sellVolumeText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: amount).doubleValue)
            
            var per = DoubleDecimalUtils.div(amount, DoubleDecimalUtils.newInstance(mAmountMaxSell)) / 100
            
            let volumeAllSize = self.view.frame.size.width / 3.0
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
        mAmountMaxBuy = 0
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
                if(mAmountMaxBuy < a){mAmountMaxBuy = a}
            }else{
                buy["amount"] = nil
            }
            mArrayHogyBuy.append(buy)
        }
        
    }
    
    fileprivate func initHogaSellData(){
        mArrayHogySell.removeAll();
        mAmountSell = 0
        mAmountMaxSell = 0
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
                if(mAmountMaxSell < a){mAmountMaxSell = a}
            }else{
                sell["amount"] = nil
            }
            mArrayHogySell.append(sell)
        }
        
    }
}




//MARK: - contractLayout
extension VCCoinDetailHoga{
    fileprivate func contractLayout(){
        initContractData()
        contractData()
    }
    
    fileprivate func contractData(){
        buyAllVolumText.text = DoubleDecimalUtils.removeLastZero(String(format: "%.8f", mAmountBuy))
        for idx in (0 ..< HOGAMAX){
            let hoga = mArrayContract[idx]
            
            if(hoga == nil){
                contractPriceText[idx].text = " "
                contractAmountText[idx].text = " "
            }
            
            let type = hoga?["type"] as? String
            let price = DoubleDecimalUtils.newInstance(hoga?["price"] as? String)
            let amount = DoubleDecimalUtils.newInstance(hoga?["amount"] as? String)
                
            contractPriceText[idx].text = String(format: "%.8f", NSDecimalNumber(decimal: price).doubleValue)
            contractAmountText[idx].text = String(format: "%.4f", NSDecimalNumber(decimal: amount).doubleValue)
            
            if type == "1" {
                contractAmountText[idx].textColor = UIColor(named: "HogaPriceRed")
            }else{
                contractAmountText[idx].textColor = UIColor(named: "HogaPriceBlue")
            }
            
            if(closingPrice > 0){
                if let cur_price = Double(String(format: "%.8f", NSDecimalNumber(decimal: price).doubleValue)){
                    if(cur_price > closingPrice){
                        contractPriceText[idx].textColor = UIColor(named: "HogaPriceRed")
                    }else if(cur_price < closingPrice){
                        contractPriceText[idx].textColor = UIColor(named: "HogaPriceBlue")
                    }else{
                        contractPriceText[idx].textColor = UIColor(named: "HogaPriceGray")
                    }
                }
            }
        }
    }
    
    fileprivate func initContractData(){
        mArrayContract.removeAll();
        closingPrice = (appInfo.getFirebaseHoga()?.getHOGASUB(VCCoinDetail.coin?.coin_code ?? "")?["CLOSING_PRICE"] as? Double) ?? 0
        
        for idx in (1 ... HOGAMAX){
            guard let hoga = appInfo.getFirebaseHoga()?.getCONTRACT(VCCoinDetail.coin?.coin_code ?? "") else{
                mArrayContract.append(nil)
                continue
            }
            
            guard let contract = hoga["contract_" + String(idx)] as? [String:Any?] else {
                mArrayContract.append(nil)
                continue
            }
            
            var item = [String:Any?]()
            if let type = contract["sellbuy_gubun"]{
                item["type"] = type
            }else{
                item["type"] = "1"
            }
            if let price = contract["trd_price"]{
                item["price"] = price
            }else{
                item["price"] = "0"
            }
            if let amount = contract["trd_qty"]{
                item["amount"] = amount
            }else{
                item["amount"] = "0"
            }
            
            mArrayContract.append(item)
        }
        
    }
}


//MARK: - infoLayout
extension VCCoinDetailHoga{
    fileprivate func infoLayout(){
        infoMarketText.text = VCCoinDetail.MARKETTYPE
        infoCoinText.text = VCCoinDetail.coin?.coin_code
        guard let hogaSub = appInfo.getFirebaseHoga()?.getHOGASUB(VCCoinDetail.coin?.coin_code ?? "") else{
            return
        }
        
        let amountTotalBuy = DoubleDecimalUtils.newInstance(toString(hogaSub["AMOUNT_TOTAL_BUY"]))
        let amountTotalSell = DoubleDecimalUtils.newInstance(toString(hogaSub["AMOUNT_TOTAL_SELL"]))
        let closingPrice = DoubleDecimalUtils.newInstance(toString(hogaSub["CLOSING_PRICE"]))
        let highPriceToday = DoubleDecimalUtils.newInstance(toString(hogaSub["HIGH_PRICE_TODAY"]))
        let lowPriceToday = DoubleDecimalUtils.newInstance(toString(hogaSub["LOW_PRICE_TODAY"] ))
        let todayTotalCost = DoubleDecimalUtils.newInstance(toString(hogaSub["TODAY_TOTAL_COST"] ))
        let highPrice24h = DoubleDecimalUtils.newInstance(toString(hogaSub["HIGH_PRICE_24H"] ))
        let lowPrice24h = DoubleDecimalUtils.newInstance(toString(hogaSub["LOW_PRICE_24H"] ))
        let priceNow = DoubleDecimalUtils.newInstance(toString(hogaSub["PRICE_NOW"] ))
        
        let totalAmountToday = amountTotalBuy + amountTotalSell
        let contractStrength = amountTotalSell / amountTotalBuy
        
        let highPrice214hPer = ((highPrice24h - priceNow) / priceNow) * Decimal(100)
        let lowPrice214hPer = ((lowPrice24h - priceNow) / priceNow) * Decimal(100)
        let change = priceNow - closingPrice
        let changePer = (change / closingPrice) * Decimal(100)
        
        infoPriceText1.text = String(format: "%.2f", NSDecimalNumber(decimal: todayTotalCost).doubleValue)
        infoPriceText2.text = String(format: "%.2f", NSDecimalNumber(decimal: totalAmountToday).doubleValue)
        infoPriceText3.text = String(format: "%.2f", NSDecimalNumber(decimal: contractStrength).doubleValue)
        if let v = Double(infoPriceText3.text!){
            infoPriceText3.text = infoPriceText3.text! + "%"
            if(v > 0){
                infoPriceText3.textColor = UIColor(named: "HogaPriceRed")
                infoPriceText3.text = "+" + infoPriceText3.text!
            }else if(v < 0){
                infoPriceText3.textColor = UIColor(named: "HogaPriceBlue")
            }else{
                infoPriceText3.text = infoPriceText3.text?.replacingOccurrences(of: "-", with: "")
            }
        }
        
        
        infoPriceText4.text = String(format: "%.8f", NSDecimalNumber(decimal: closingPrice).doubleValue)
        
        infoPriceText5.text = String(format: "%.8f", NSDecimalNumber(decimal: change).doubleValue)
        if let v = Double(infoPriceText5.text!){
            if(v > 0){
                infoPriceText5.textColor = UIColor(named: "HogaPriceRed")
                infoPriceText5.text = "+" + infoPriceText4.text!
            }else if(v < 0){
                infoPriceText5.textColor = UIColor(named: "HogaPriceBlue")
            }else{
                infoPriceText5.text = infoPriceText5.text?.replacingOccurrences(of: "-", with: "")
            }
        }
        
        
        infoPriceText5_2.text = String(format: "%.2f", NSDecimalNumber(decimal: changePer).doubleValue)
        if let v = Double(infoPriceText5_2.text!){
            infoPriceText5_2.text = infoPriceText5_2.text! + "%"
            if(v > 0){
                infoPriceText5_2.textColor = UIColor(named: "HogaPriceRed")
                infoPriceText5_2.text = "+" + infoPriceText4.text!
            }else if(v < 0){
                infoPriceText5_2.textColor = UIColor(named: "HogaPriceBlue")
            }else{
                infoPriceText5_2.text = infoPriceText5_2.text?.replacingOccurrences(of: "-", with: "")
            }
        }
        
        infoPriceText6.text = String(format: "%.8f", NSDecimalNumber(decimal: highPriceToday).doubleValue)
        infoPriceText7.text = String(format: "%.8f", NSDecimalNumber(decimal: lowPriceToday).doubleValue)
        infoPriceText8.text = String(format: "%.8f", NSDecimalNumber(decimal: highPrice24h).doubleValue)
        infoPriceText9.text = String(format: "%.8f", NSDecimalNumber(decimal: lowPrice24h).doubleValue)
        
        
        
        
    }
    
    fileprivate func toString(_ data:Any?) -> String?{
        if let a = data as? String{
            return a
        }
        if let a = data as? Double{
            return String(a)
        }
        if let a = data as? Int64{
            return String(a)
        }
        return nil
    }
}


