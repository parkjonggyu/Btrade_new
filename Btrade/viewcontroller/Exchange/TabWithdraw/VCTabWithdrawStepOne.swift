//
//  VCTabWithdrawStepOne.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/19.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCTabWithdrawStepOne:VCBase {
    var vcTabWithdraw:VCTabWithdraw?
    
    @IBOutlet weak var editBoxLayout: UIView!
    
    @IBOutlet weak var ableTotalPriceText: UILabel!
    @IBOutlet weak var krwPriceText: UILabel!
    @IBOutlet weak var feePriceText: UILabel!
    @IBOutlet weak var withdrawTotalPriceText: UILabel!
    
    @IBOutlet weak var curCoinCodeText1: UILabel!
    @IBOutlet weak var curCoinCodeText2: UILabel!
    @IBOutlet weak var curCoinCodeText3: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var amountEdit: UITextField!
    @IBOutlet weak var allBtn: UILabel!
    
    var limitAmountCount:Double = 0 //일일 출금 가능 횟수
    var minLimit:Double = 0  //최소 출금 금액
    var exchangeCan:Double = 0 // 출금 가능 금액
    var shuffleHpxAddress = "" // 뭔지 모름
    var todayRemainLimit:Double = 0 //일일 출금 한도
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }
    
    func start() {
        initLayout()
        getData()
    }
    
    fileprivate func getData(){
        let request = WithdrawInfoRequest()
        request.coinType = vcTabWithdraw?.vcExchangeDetail?.coinCode
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    fileprivate func initLayout(){
        editBoxLayout.layer.cornerRadius = 10
        editBoxLayout.layer.borderWidth = 1
        editBoxLayout.layer.borderColor = UIColor(named: "CD5D5D5")?.cgColor
        amountEdit.borderStyle = .none
        amountEdit.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        curCoinCodeText1.text = ""
        curCoinCodeText2.text = ""
        curCoinCodeText3.text = ""
        amountEdit.text = ""
        ableTotalPriceText.text = "0"
        krwPriceText.text = "0"
        feePriceText.text = "0"
        withdrawTotalPriceText.text = "0"
        withdrawTotalPriceText.textColor = UIColor(named: "C515151")
        
        allBtn.isUserInteractionEnabled = true
        allBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
        
        if let code = vcTabWithdraw?.vcExchangeDetail?.coinCode{
            nextBtn.setTitle(code + " 출금하기", for: .normal)
            curCoinCodeText1.text = code
            curCoinCodeText2.text = code
            curCoinCodeText3.text = code
        }
    }
    
    @objc func onClickEvent(sender:UITapGestureRecognizer){
        if(sender.view == allBtn){
            
        }
    }
    
    @IBAction func goNext(_ sender: Any) {
        if(errorCheckAmount() == nil){
            let val = Double(amountEdit.text!)!
            if val > exchangeCan{
                withdrawTotalPriceText.textColor = UIColor(named: "HogaPriceRed")
                showErrorDialog("출금 가능금액 이하로 출금하실 수 있습니다.")
                return
            }else if val < minLimit{
                withdrawTotalPriceText.textColor = UIColor(named: "C515151")
                showErrorDialog("최소 출금금액 " + DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(minLimit))) + " " + (vcTabWithdraw?.vcExchangeDetail?.coinCode ?? "") + " 이상으로 출금하실 수 있습니다.")
                return
            }else{
                withdrawTotalPriceText.textColor = UIColor(named: "C515151")
            }
            nextStep()
        }else{
            showErrorDialog(errorCheckAmount()!)
            return
        }
        
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? WithdrawInfoRequest{
            let response = WithdrawInfoResponse(baseResponce: response)
            
            limitAmountCount = response.getLimitAmountCount()
            minLimit = response.getMinLimit()
            let realExchangeCan = response.getRealExchangeCan()
            let temp = CoinUtils.currency(DoubleDecimalUtils.withoutExp(realExchangeCan), 8)
            let placeHolder = "최소 " + DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(minLimit))) + " " + (vcTabWithdraw?.vcExchangeDetail?.coinCode ?? "")
            shuffleHpxAddress = response.getShuffleHpxAddress() ?? ""
            todayRemainLimit = response.getTodayRemainLimit()
            exchangeCan = Double(temp)!
            getFee()
            DispatchQueue.main.async{ [self] in
                self.amountEdit.placeholder = placeHolder
            }
        }
    }
}


//MARK: - Firebase
extension VCTabWithdrawStepOne:FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        
        
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        setValue()
    }
    
    fileprivate func toDouble(_ data:Any?) -> Double{
        if let a = data as? Double{
            return a
        }
        if let a = data as? Int64{
            return Double(a)
        }
        if let a = data as? String{
            return Double(a) ?? 0
        }
        return 0
    }
    
    fileprivate func toString(_ data:Any?) -> String{
        if let a = data as? String{
            return a
        }
        return ""
    }
}


//MARK: - calcAmount
extension VCTabWithdrawStepOne{
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == amountEdit){
            if let checkDot = checkDot(amountEdit.text){
                amountEdit.text = checkDot
                return
            }
            
            if let checkText = check8Length(amountEdit.text){
                amountEdit.text = checkText
                return
            }
            
            if let d = Double(amountEdit.text!){
                if(d < 0){
                    amountEdit.text = "0"
                }
            }
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
    
    fileprivate func checkInputValue(){
        if(errorCheckAmount() == nil){
            let val = Double(amountEdit.text!)!
            if val > exchangeCan{
                withdrawTotalPriceText.textColor = UIColor(named: "HogaPriceRed")
            }else{
                withdrawTotalPriceText.textColor = UIColor(named: "C515151")
            }
            setValue()
        }
    }
    
    fileprivate func errorCheckAmount() -> String?{
        guard let _ = Double(amountEdit.text!) else {
            return "출금금액이 올바르지 않습니다."
        }
        return nil
    }
    
    fileprivate func setValueInError(){
        amountEdit.text = "0"
        krwPriceText.text = "0"
        withdrawTotalPriceText.text = "0"
    }
    
    fileprivate func setValue(){
        if errorCheckAmount() != nil{return}
        let price = DoubleDecimalUtils.newInstance(feePriceText.text!)
        let amount = DoubleDecimalUtils.newInstance(amountEdit.text!)
        let totalVolum = price + amount
        
        if let hogaSub = appInfo.getFirebaseHoga()?.getHOGASUB(vcTabWithdraw?.vcExchangeDetail?.coinCode ?? ""){
            let now_price = DoubleDecimalUtils.newInstance(hogaSub["PRICE_NOW"] as? Double)
            let result = amount * now_price * (self.appInfo.krwValue ?? DoubleDecimalUtils.newInstance("1"))
            krwPriceText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(DoubleDecimalUtils.doubleValue(result) ?? 0, scale: 0))
        }else{
            krwPriceText.text = "0"
        }
        
        withdrawTotalPriceText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal:totalVolum, scale: 8)))
        
    }
}


//MARK - getFee
extension VCTabWithdrawStepOne{
    fileprivate func getFee(){
        let request = CalculateFeeRequest()
        request.coinType = vcTabWithdraw?.vcExchangeDetail?.coinCode
        ApiFactory(apiResult: Fee(self), request: request).newThread()
    }
    
    class Fee:ApiResult{
        var vcTabWithdrawStepOne:VCTabWithdrawStepOne?
        init(_ vc:VCTabWithdrawStepOne){
            vcTabWithdrawStepOne = vc
        }
        
        func onResult(response: BaseResponse) {
            let response = CalculateFeeResponse(baseResponce: response)
            var tempText:String? = "0"
            var feeText:String? = "0"
            if let fee = response.getFee(){
                feeText = CoinUtils.currency(fee)
                var value = floor((vcTabWithdrawStepOne!.exchangeCan * 100000000) - (vcTabWithdrawStepOne!.toDouble(fee) * 100000000)) / 100000000
                if value < 0 {value = 0}
                tempText = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(value)))
            }else{
                tempText = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(vcTabWithdrawStepOne!.exchangeCan)))
            }
            DispatchQueue.main.async{ [self] in
                self.vcTabWithdrawStepOne?.ableTotalPriceText.text = tempText
                self.vcTabWithdrawStepOne?.feePriceText.text = feeText
            }
        }
        
        func onError(e: AFError, method: String) {}
    }
}

extension VCTabWithdrawStepOne{
    
    fileprivate func nextStep(){
        let request = WithdrawLimitRequest()
        request.coin_type = vcTabWithdraw?.vcExchangeDetail?.coinCode?.lowercased()
        request.coinType = vcTabWithdraw?.vcExchangeDetail?.coinCode
        ApiFactory(apiResult: Limit(self), request: request).newThread()
//        if let v = vcTabWithdraw{
//
//        }
    }
    class Limit:ApiResult{
        var vcTabWithdrawStepOne:VCTabWithdrawStepOne?
        init(_ vc:VCTabWithdrawStepOne){
            vcTabWithdrawStepOne = vc
        }
        
        func onResult(response: BaseResponse) {
            if let _ = response.request as? WithdrawLimitRequest{
                let response = WithdrawLimitResponse(baseResponce: response)
                if let vasps = response.getVasps(){
                    var array:Array<KycVo.SMAP> = Array<KycVo.SMAP>()
                    for vasp in vasps{
                        if let health = vasp["health"] as? String, let vaspStatus = vasp["vaspStatus"] as? String ,let id = vasp["vaspId"] as? String , let name = vasp["vaspName"] as? String {
                            if name.lowercased() != "coinhako" && vaspStatus == "VERIFIED-MEMBER" && health == "UP"{
                                let country = vasp["country"] as? String
                                array.append(KycVo.SMAP(key: name, value: id, temp: country))
                            }
                            
                        }
                    }
                    if array.count == 0{
                        self.vcTabWithdrawStepOne?.showErrorDialog("출금 가능한 거래소가 없습니다.")
                        return
                    }
                    self.vcTabWithdrawStepOne?.vcTabWithdraw?.sendData(["vasps": array])
                }
                
                
                guard let amount = self.vcTabWithdrawStepOne?.toDouble(self.vcTabWithdrawStepOne?.amountEdit.text) else { return }
                if amount < response.getOutMinCount(){
                    self.vcTabWithdrawStepOne?.showErrorDialog("출금요청 금액이 출금 최소 금액보다 작습니다.")
                    return
                }
                if amount * response.getNowPrice() < response.getOutMaxCount(){
                    self.vcTabWithdrawStepOne?.showErrorDialog("출금요청 금액이 1회 한도 금액을 초과하였습니다.")
                    return
                }
                if amount * response.getNowPrice() + response.getTodayTotalRequestAmount() < response.getOutMaxDay(){
                    self.vcTabWithdrawStepOne?.showErrorDialog("출금요청 금액이 일일 한도 금액을 초과하였습니다.")
                    return
                }
                
                self.vcTabWithdrawStepOne?.vcTabWithdraw?.sendData(["feeText": self.vcTabWithdrawStepOne?.feePriceText.text])
                self.vcTabWithdrawStepOne?.vcTabWithdraw?.sendData(["amountText": self.vcTabWithdrawStepOne?.amountEdit.text])
                
                self.vcTabWithdrawStepOne?.vcTabWithdraw?.setView(1)
                
            }
            
        }
        
        func onError(e: AFError, method: String) {}
    }
}

