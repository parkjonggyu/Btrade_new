//
//  VCCoinDetailOrderSell.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/02.
//

import FirebaseDatabase
import UIKit
import Alamofire

class VCCoinDetailOrderSell: VCBase{
    let trd_type = "S"
    var available_market_price:Double = 0.0
    
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
    @IBOutlet weak var coinCodeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
        
        amountEditText.delegate = self
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
            nextBtn.setBackgroundImage(UIImage(named: "btn_back_blue"), for: .normal)
            nextBtn.setTitle("매도", for: .normal)
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
        if let code = VCCoinDetail.coin?.coin_code{
            coinCodeText.text = code
        }
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
            let price = hoga["hoga_buy_1"] as? String
            priceEditText.text = DoubleDecimalUtils.setMaximumFractionDigits(NSDecimalNumber(decimal: DoubleDecimalUtils.newInstance(price)).doubleValue, scale: getScale())
        }
    }
    
    fileprivate func getScale() -> Int{
        let scale = 8;
        return scale
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        if(appInfo.getIsLogin()){
            tradeEvent()
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
        let request = CoinBalanceRequest()
        request.coinType = VCCoinDetail.coin?.coin_code ?? ""
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? CoinBalanceRequest{
            let response = CoinBalanceResponse(baseResponce: response)
            if let account = response.getAccount(){
                if(account == "false" || account == "no_session" || account == "no_coin"){
                    available_market_price = 0.0
                    setInitValue()
                }else{
                    do{
                        let a = try JSONSerialization.jsonObject(with: Data(account.utf8), options: []) as? NSDictionary
                        if let b = a?[VCCoinDetail.coin?.coin_code ?? "BTC"] as? NSDictionary{
                            if let value = b["trade_can"] as? Double{
                                available_market_price = value
                            }
                            if let value = b["trade_can"] as? Int64{
                                available_market_price = Double(value)
                            }
                            setFirebaseData()
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
        DispatchQueue.main.async{
            if let _ = response.request as? OrderRequest{
                let response = OrderResponse(baseResponce: response)
                if let status = response.getStatus(){
                    if(status == "201"){
                        // 거래비밀번호 등록 팝업 - 삭제됨
                        return
                    }else if(status == "202"){
                        // 거래비밀번호 등록 팝업 - 삭제됨
                        return
                    }else if(status == "203"){
                        // 거래비밀번호 4회 틀림 찾기 팝업 - 삭제됨
                        return
                    }else if(status == "204"){
                        // 거래비밀번호 저장 팝업 - 삭제됨
                        return
                    }else if(status == "205"){
                        // 거래비밀번호 잠금 팝업 - 삭제됨
                        return
                    }else if(status == "206"){
                        DialogUtils().makeDialog(
                        uiVC: self,
                        title: "고객확인제도",
                        message:"고객확인 인증 절차를 완료한 후, 모든 거래서비스, 입출금 이용이 가능합니다.",
                        UIAlertAction(title: "고객확인제도 인증", style: .default) { (action) in
                            self.appInfo.isKycVisible = true
                            UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
                        },
                        UIAlertAction(title: "다음에 하기", style: .destructive) { (action) in
                        })
                        return
                    }else if(status == "0001" || status == "0003" || status == "0006"){
                        if let message = response.getMessage(){// 주문 수량, 주문 가격 , 최소 주문 수량 오류
                            self.showErrorDialog(message)
                        }
                        return
                    }else if(status == "9999"){// 마켓코드 미기입 오류
                        if let message = response.getMessage(){
                            self.showErrorDialog(message)
                        }
                        return
                    }else if(status == "0009"){
                        self.showErrorDialog("처리 진행중인 주문이 있습니다. 잠시 후 다시 시도해 주세요.")
                        return
                    }else if(status == "0000"){
                        if let message = response.getMessage(){// 주문 정상 처리
                            self.tradeOkPopup(message)
                        }
                        
                        return
                    }
                }
            }
        }
    }
    
    override func onError(e: AFError, method: String) {}
}

//MARK: - EditTExt
extension VCCoinDetailOrderSell{
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == priceEditText){
            if let checkDot = checkDot(priceEditText.text){
                amountEditText.text = checkDot
                return
            }
            
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
            if let checkDot = checkDot(amountEditText.text){
                amountEditText.text = checkDot
                return
            }
            
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
        if(temp?.count ?? 2 != 2){return nil}
        
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
    
    fileprivate func checkDot(_ text:String?) -> String?{
        if(text == nil){return nil}
        guard let _ = Decimal(string:text!) else {
            return nil
        }
        var temp = text?.components(separatedBy: ".")
        if(temp?.count ?? 0 <= 2){return nil}
        
        if(temp?[0].count == 0){
            temp?[0] = "0"
        }
        
        var result = (temp?[0] ?? "0") + "."
        let size = temp?.count ?? 0
        for idx in 1 ..< size{
            result = result + (temp?[idx] ?? "")
        }
        return result
    }
    
    func setPrice(_ price:String){
        priceEditText.text = DoubleDecimalUtils.setMaximumFractionDigits(NSDecimalNumber(decimal: DoubleDecimalUtils.newInstance(price)).doubleValue, scale: getScale())
        checkInputValue()
    }
}
extension VCCoinDetailOrderSell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = amountEditText.text{
            if(text == "0"){amountEditText.text = ""}
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = amountEditText.text{
            if(text == ""){amountEditText.text = "0"}
        }
    }
}

//MARK: - Spinner
extension VCCoinDetailOrderSell: SpinnerSelectorInterface{
    func onSelect(_ item: KycVo.SMAP, _ CATE: Int) {
        volumSpinner.text = item.key
        if var per = Double(item.value){
            per = per / 100.0
            let available = available_market_price * (1 - Double(Global.tradeFeeRate)!)
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
extension VCCoinDetailOrderSell: FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        setFirebaseData()
    }
    
    
}

//MARK: - ChangeValue
extension VCCoinDetailOrderSell{
    fileprivate func setFirebaseData(){
        DispatchQueue.main.async{
            let value = DoubleDecimalUtils.newInstance(self.available_market_price)
            self.avalilabeText.text = DoubleDecimalUtils.setMaximumFractionDigits(decimal: value, scale: self.getScale())
            if let hogaSub = self.appInfo.getFirebaseHoga()?.getHOGASUB(VCCoinDetail.coin?.coin_code ?? ""){
                let now_price = DoubleDecimalUtils.newInstance(hogaSub["PRICE_NOW"] as? Double)
                let result = value * now_price * (self.appInfo.krwValue ?? DoubleDecimalUtils.newInstance("1"))
                self.availableKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(DoubleDecimalUtils.doubleValue(result) ?? 0, scale: 0))
            }
            
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
            return "매도가가 올바르지 않습니다."
        }
        guard let _ = Double(amountEditText.text!) else {
            return "매도량이 올바르지 않습니다."
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
        
        let tempFee = DoubleDecimalUtils.setMaximumFractionDigits(DoubleDecimalUtils.mul(DoubleDecimalUtils.newInstance(totalVolum), DoubleDecimalUtils.newInstance(Global.tradeFeeRate)), scale: 8)
        let tradeFee = ceil((Double(tempFee) ?? 0) * 100000000) / 100000000
        let krwPrice = DoubleDecimalUtils.mul(DoubleDecimalUtils.newInstance(totalVolum), appInfo.krwValue!)
        totalPriceText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(totalVolum), 0))
        feeText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(tradeFee), 0))
        totalPriceKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(krwPrice, scale: 0))
        
        if(checkAmountOver(totalVolum + tradeFee, available_market_price)){
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
extension VCCoinDetailOrderSell{
    
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


//MARK: - tradeEvent
extension VCCoinDetailOrderSell{
    
    fileprivate func tradeEvent(){
        if(calcWithPriceAndAmount() != nil){
            showErrorDialog(calcWithPriceAndAmount()!)
            return
        }
        if(checkAmount() != nil){
            showErrorDialog(checkAmount()!)
            return
        }
        
        checkUser()
    }
    
    fileprivate func checkAmount() -> String?{
        let amountValue = DoubleDecimalUtils.newInstance(amountEditText.text)
        let priceValue = DoubleDecimalUtils.newInstance(priceEditText.text)
        let tempFee1 = DoubleDecimalUtils.setMaximumFractionDigits(DoubleDecimalUtils.mul(amountValue, DoubleDecimalUtils.newInstance(Global.tradeFeeRate)), scale: 8)
        let tempFee2 = ceil((Double(tempFee1) ?? 0) * 100000000) / 100000000
        let tradeFee =  DoubleDecimalUtils.newInstance(DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(tempFee2), 0)))
        let totalVolume = DoubleDecimalUtils.mul(tradeFee + amountValue, priceValue)
        if(totalVolume > Global.MAX_ORDER_VOLUME){
            return "1회에 주문가능한 주문 총액을 초과 하였습니다."
        }else if (totalVolume < Global.MIN_ORDER_VOLUME){
            return "최소 거래금액은 " + String(Global.MIN_ORDER_VOLUME) + (VCCoinDetail.MARKETTYPE ?? "BTC") + " 이상입니다."
        }
        
        if(checkAmountOver(totalVolume, available_market_price)){
            return "주문 가능 수량이 부족합니다."
        }
        
        if(totalVolume > Global.MAX_ORDER_COIN_BTC){
            return "최대 거래금액은 10BTC 이하입니다."
        }
        
        return nil
    }
    
    fileprivate func checkUser(){
        if let error = orderValidation(){
            if(error != ""){
                showErrorDialog(error)
                return
            }else{
                return
            }
        }
        
        orderValidationExtrad()
    }
    
    fileprivate func orderValidation() -> String?{
        guard let _ = appInfo.getMemberInfo() else {
            UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
            return ""
        }
        
        let info = appInfo.getMemberInfo()!
        if let aml = info.aml_state{
            if aml == "N" || CoinUtils.getlevel(info) == 1 {
                DialogUtils().makeDialog(
                uiVC: self,
                title: "고객확인제도",
                message:"고객확인 인증 절차를 완료한 후, 모든 거래서비스, 입출금 이용이 가능합니다.",
                UIAlertAction(title: "고객확인제도 인증", style: .default) { (action) in
                    self.appInfo.isKycVisible = true
                    UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
                },
                UIAlertAction(title: "다음에 하기", style: .destructive) { (action) in
                })
                return ""
            }
            
            if aml != "cc"{
                return "고객확인 인증을 진행중입니다."
            }
            
            return nil
        }
        
        return "오류가 발생했습니다."
    }
    
    fileprivate func orderValidationExtrad(){
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "TradeComfirmPopup") as? TradeComfirmPopup else {
            return
        }
        vc.trd_type = trd_type
        vc.coinCode = VCCoinDetail.coin?.coin_code
        vc.coinKrName = VCCoinDetail.coin?.kr_coin_name
        vc.marketType = VCCoinDetail.MARKETTYPE
        vc.volume = amountEditText.text
        vc.price = priceEditText.text
        vc.fee = feeText.text
        let totalPrice = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.newInstance(totalPriceText.text) + DoubleDecimalUtils.newInstance(feeText.text))
        vc.totalPrice = totalPrice
        vc.nextStep = {() -> Void in
            self.executeOrder()
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true);
    }
    
    fileprivate func executeOrder(){
        let request = OrderRequest()
        request.coin_code = VCCoinDetail.coin?.coin_code
        request.market_code = VCCoinDetail.MARKETTYPE
        request.trd_type = trd_type
        request.tradePw = "1111".toBase64()
        request.trade_pw_check = "N"
        request.amtBuy = amountEditText.text
        request.priceBuy = priceEditText.text
        request.krw_price = NSDecimalNumber(decimal: appInfo.krwValue!).stringValue
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    fileprivate func tradeOkPopup(_ msg:String){
        
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "TradeCompletePopup") as? TradeCompletePopup else {
            return
        }
        vc.message = msg
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true);
        
        changeValue()
    }
    
    fileprivate func changeValue(){
        let available = DoubleDecimalUtils.newInstance(avalilabeText.text)
        let totalPrice = DoubleDecimalUtils.newInstance(totalPriceText.text)
        let feePrice = DoubleDecimalUtils.newInstance(feeText.text)
        let result = available - (totalPrice + feePrice)
        
        available_market_price = DoubleDecimalUtils.doubleValue(result)!
        let value = DoubleDecimalUtils.newInstance(self.available_market_price)
        self.avalilabeText.text = DoubleDecimalUtils.setMaximumFractionDigits(decimal: value, scale: self.getScale())
        
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
        setFirebaseData()
    }
}

extension String {
    fileprivate func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

