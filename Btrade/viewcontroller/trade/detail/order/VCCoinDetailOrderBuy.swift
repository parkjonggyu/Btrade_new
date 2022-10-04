//
//  VCCoinDetailOrderBuy.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/02.
//

import FirebaseDatabase
import UIKit
import Alamofire


class VCCoinDetailOrderBuy: VCBase{
    var available_market:Double = 0.0
    
    @IBOutlet weak var priceBox: UIView!
    @IBOutlet weak var volumeBox: UIView!
    
    @IBOutlet weak var avalilabeText: UILabel!
    @IBOutlet weak var availableKrwText: UILabel!
    
    @IBOutlet weak var totalPriceText: UILabel!
    @IBOutlet weak var totalPriceKrwText: UILabel!
    @IBOutlet weak var feeText: UILabel!
    
    @IBOutlet weak var priceEditText: UITextField!
    @IBOutlet weak var amountEditText: UITextField!
    
    @IBOutlet weak var volumSpinner: UILabel!
    @IBOutlet weak var priceMinusBtn: UILabel!
    @IBOutlet weak var pricePlusBtn: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
        
        volumSpinner.isUserInteractionEnabled = true
        volumSpinner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startDropDown)))
        pricePlusBtn.isUserInteractionEnabled = true
        pricePlusBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusMinusEvent)))
        priceMinusBtn.isUserInteractionEnabled = true
        priceMinusBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusMinusEvent)))
        
        priceEditText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        amountEditText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setInitValue()
        if(appInfo.getIsLogin()){
            nextBtn.setBackgroundImage(UIImage(named: "btn_back_red"), for: .normal)
            nextBtn.setTitle("매수", for: .normal)
            
            getData()
        }else{
            nextBtn.setBackgroundImage(UIImage(named: "btn_all_active"), for: .normal)
            nextBtn.setTitle("로그인", for: .normal)
        }
    }
    
    
    fileprivate func initDesign(){
        priceBox.layer.borderWidth = 1
        priceBox.layer.borderColor = UIColor.gray.cgColor
        priceBox.layer.cornerRadius = 3
        volumeBox.layer.borderWidth = 1
        volumeBox.layer.borderColor = UIColor.gray.cgColor
        volumeBox.layer.cornerRadius = 3
        priceEditText.borderStyle = .none
        amountEditText.borderStyle = .none
    }
    
    fileprivate func setInitValue(){
        avalilabeText.text = "0"
        availableKrwText.text = "0"
        totalPriceText.text = "0"
        totalPriceKrwText.text = "0"
        feeText.text = "0"
        amountEditText.text = "0"
        priceEditText.text = "0"
        volumSpinner.text = "가능 ▼"
        if let hoga = VCCoinDetail.coin?.firebaseHoga?.getHOGA(){
            let price = hoga["hoga_sell_1"] as? String
            priceEditText.text = DoubleDecimalUtils.setMaximumFractionDigits(NSDecimalNumber(decimal: DoubleDecimalUtils.newInstance(price)).doubleValue, scale: getScale())
        }
    }
    
    fileprivate func getScale() -> Int{
        let scale = 8;
        return scale
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        if(appInfo.getIsLogin()){
            nextBtn.setBackgroundImage(UIImage(named: "btn_back_red"), for: .normal)
            nextBtn.setTitle("매수", for: .normal)
        }else{
            let sb = UIStoryboard.init(name:"Login", bundle: nil)
            guard let mainvc = sb.instantiateViewController(withIdentifier: "loginvc") as? UINavigationController else {
                return
            }
            mainvc.modalPresentationStyle = .fullScreen
            self.present(mainvc, animated: true);
        }
    }
    
    //MARK - ApiFactory
    fileprivate func getData(){
        let request = MarketBalanceRequest()
        request.coinType = VCCoinDetail.MARKETTYPE ?? ""
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? MarketBalanceRequest{
            let response = MarketBalanceResponse(baseResponce: response)
            if let account = response.getAccount(){
                if(account == "false" || account == "no_session" || account == "no_coin"){
                    available_market = 0.0
                    setInitValue()
                }else{
                    do{
                        let a = try JSONSerialization.jsonObject(with: Data(account.utf8), options: []) as? NSDictionary
                        if let b = a?[VCCoinDetail.MARKETTYPE ?? "BTC"] as? NSDictionary{
                            if let value = b["trade_can"] as? Double{
                                available_market = value
                            }
                            if let value = b["trade_can"] as? Int64{
                                available_market = Double(value)
                            }
                            setFirebaseData()
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
    }
    
    override func onError(e: AFError, method: String) {}
}

//MARK: - EditTExt
extension VCCoinDetailOrderBuy{
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == priceEditText){
            if let checkText = check8Length(priceEditText.text){
                priceEditText.text = checkText
                return
            }
            
            if let d = Double(priceEditText.text!){
                if(d < 0){
                    priceEditText.text = "0"
                }else if(d > Global.MAX_ORDER_PRICE){
                    priceEditText.text = String(Global.MAX_ORDER_PRICE)
                }
            }
            volumSpinner.text = "가능 ▼"
            checkInputValue()
        }else if(sender == amountEditText){
            if let checkText = check8Length(amountEditText.text){
                amountEditText.text = checkText
                return
            }
            
            if let d = Double(amountEditText.text!){
                if(d < 0){
                    amountEditText.text = "0"
                }else if(d > Global.MAX_ORDER_VOLUME){
                    amountEditText.text = String(Global.MAX_ORDER_VOLUME)
                }
            }
            volumSpinner.text = "가능 ▼"
            checkInputValue()
        }
    }
    
    fileprivate func check8Length(_ text:String?) -> String?{
        let scale = 8
        if(text == nil){return nil}
        guard let _ = Decimal(string:text!) else {
            return nil
        }
        var temp = text?.components(separatedBy: ".")
        if(temp?.count != 2){return nil}
        
        if((temp?[1].count)! > scale){
            if(temp?[0].count == 0){
                temp?[0] = "0"
            }
            return (temp?[0] ?? "0") + "." + (temp?[1].substring(from: 0, to: scale) ?? "0")
        }
        
        if(temp?[0].count == 0){
            return "0" + "." + (temp?[1] ?? "0")
        }
        
        return nil
    }
}


//MARK: - Spinner
extension VCCoinDetailOrderBuy: SpinnerSelectorInterface{
    func onSelect(_ item: KycVo.SMAP, _ CATE: Int) {
        volumSpinner.text = item.key
        if var per = Double(item.value){
            per = per / 100.0
            let available = available_market * (1 - Double(Global.tradeFeeRate)!)
            let price = DoubleDecimalUtils.newInstance(priceEditText.text)
            if let price1 = DoubleDecimalUtils.doubleValue(price){
                amountEditText.text = DoubleDecimalUtils.setMaximumFractionDigits((available * per) / price1, scale: 8)
                checkInputValue()
                return;
            }
        }
        volumSpinner.text = "가능 ▼"
    }
    
    @objc func startDropDown(sender:UITapGestureRecognizer){
        guard let _ = Decimal(string:priceEditText.text ?? "") else{
            showErrorDialog("주문 가격을 먼저 입력해 주세요.")
            return
        }
        var mArray = Array<KycVo.SMAP>()
        mArray.append(KycVo.SMAP(key: "100%", value: "100"));
        mArray.append(KycVo.SMAP(key: "75%", value: "75"));
        mArray.append(KycVo.SMAP(key: "50%", value: "50"));
        mArray.append(KycVo.SMAP(key: "25%", value: "25"));
        SpinnerSelector(self, volumSpinner, mArray, 0).start()
    }
}

//MARK: - FireBase
extension VCCoinDetailOrderBuy: FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        setFirebaseData()
    }
    
    
}

//MARK: - ChangeValue
extension VCCoinDetailOrderBuy{
    fileprivate func setFirebaseData(){
        DispatchQueue.main.async{
            let value = DoubleDecimalUtils.newInstance(self.available_market)
            self.avalilabeText.text = DoubleDecimalUtils.setMaximumFractionDigits(decimal: value, scale: self.getScale())
            self.availableKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(DoubleDecimalUtils.mul(value, self.appInfo.krwValue!), scale: 0))
            
            let totalPrice = self.totalPriceText.text ?? "0"
            if(totalPrice != "0"){
                self.totalPriceKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(DoubleDecimalUtils.mul(totalPrice, self.appInfo.krwValue!), scale: 0))
            }
        }
    }
    
    fileprivate func checkInputValue(){
        if(calcWithPriceAndAmount() == nil){
            setValue()
        }else{
            setValueInError()
        }
    }
    
    fileprivate func calcWithPriceAndAmount() -> String?{
        guard let _ = Double(priceEditText.text!) else {
            return "매수가가 올바르지 않습니다."
        }
        guard let _ = Double(amountEditText.text!) else {
            return "매수량이 올바르지 않습니다."
        }
        return nil
    }
    
    fileprivate func setValueInError(){
        totalPriceText.text = "0"
        feeText.text = "0"
        totalPriceKrwText.text = "0"
    }
    
    fileprivate func setValue(){
        let price = DoubleDecimalUtils.newInstance(priceEditText.text!)
        let amount = DoubleDecimalUtils.newInstance(amountEditText.text!)
        let totalVolum = DoubleDecimalUtils.mul(price, amount)
        let tradeFee = ceil(DoubleDecimalUtils.mul(DoubleDecimalUtils.newInstance(totalVolum), DoubleDecimalUtils.newInstance(Global.tradeFeeRate)) * 100000000) / 100000000
        let krwPrice = DoubleDecimalUtils.mul(DoubleDecimalUtils.newInstance(totalVolum), appInfo.krwValue!)
        totalPriceText.text = CoinUtils.currency(DoubleDecimalUtils.withoutExp(totalVolum), 0);
        feeText.text = CoinUtils.currency(DoubleDecimalUtils.withoutExp(tradeFee), 0);
        totalPriceKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(krwPrice, scale: 0));
        
        if(checkAmountOver(totalVolum + tradeFee, available_market)){
            totalPriceText.textColor = UIColor(named: "HogaPriceRed")
        }else{
            totalPriceText.textColor = UIColor(named: "C515151")
        }
    }
            
    fileprivate func checkAmountOver(_ totalVolmue:Double, _ available:Double) -> Bool{
        if(totalVolmue > available){
            return true
        }
        return false
    }
}

//MARK: - PlusMinusEvent
extension VCCoinDetailOrderBuy{
    
    @objc func plusMinusEvent(sender:UITapGestureRecognizer){
        guard let _ = Decimal(string:priceEditText.text ?? "") else{
            return
        }
        
        let price = DoubleDecimalUtils.newInstance(priceEditText.text)
        let hogaUnit = DoubleDecimalUtils.newInstance(CoinUtils.hogaPolicy(VCCoinDetail.MARKETTYPE, NSDecimalNumber(decimal: price).doubleValue))
        var result = 0.0
        if(sender.view == pricePlusBtn){
            result = DoubleDecimalUtils.add(price, hogaUnit)
        }else{
            result = DoubleDecimalUtils.subtract(price, hogaUnit)
        }
        priceEditText.text = CoinUtils.currency(DoubleDecimalUtils.withoutExp(result), 0)
        volumSpinner.text = "가능 ▼"
        checkInputValue()
        print("")
    }
}
