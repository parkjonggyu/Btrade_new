//
//  VCTabWithdrawStepTwo.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/19.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCTabWithdrawStepTwo:VCBase , SpinnerSelectorInterface{
    
    var vcTabWithdraw:VCTabWithdraw?
    var vasps:Array<KycVo.SMAP>?
    var feeText: String?
    var amountText: String?
    var vaspSelected = ""
    var vaspCountry:String? = "kr"
    var withdrawState = false
    
    @IBOutlet weak var coinCodeText1: UILabel!
    @IBOutlet weak var coinCodeText2: UILabel!
    @IBOutlet weak var coinCodeText3: UILabel!
    
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var amountPriceText: UILabel!
    @IBOutlet weak var feePriceText: UILabel!
    @IBOutlet weak var totalPriceText: UILabel!
    @IBOutlet weak var vaspsSpinner: UILabel!
    @IBOutlet weak var receiverEdit: UITextField!
    @IBOutlet weak var addressEdit: UITextField!
    @IBOutlet weak var destinationTagEdit: UITextField!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var destinationBack: UILabel!
    @IBOutlet weak var addressBack: UILabel!
    @IBOutlet weak var receiverBack: UILabel!
    
    @IBOutlet weak var statusLayout: NSLayoutConstraint!
    @IBOutlet weak var destinationLayout: NSLayoutConstraint!
    
    var statusLayoutValue:CGFloat = 0
    var destinationLayoutValue:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLayoutValue = statusLayout.constant
        destinationLayoutValue = destinationLayout.constant
    }
    
    func initLayout(){
        setValue()
        withdrawState = false
        statusLayout.constant = 0
        destinationLayout.constant = 0
        statusText.text = "정상"
        statusText.textColor = UIColor(named: "HogaPriceBlue")
        vaspSelected = ""
        vaspsSpinner.text = "받으실 거래소를 선택해 주세요."
        
        
        if let code = vcTabWithdraw?.vcExchangeDetail?.coinCode{
            nextBtn.setTitle(code + " 출금하기", for: .normal)
            coinCodeText1.text = code
            coinCodeText2.text = code
            coinCodeText3.text = code
        }
        
        
        receiverEdit.delegate = self
        addressEdit.delegate = self
        destinationTagEdit.delegate = self
        
        receiverEdit.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        addressEdit.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        destinationTagEdit.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        vaspsSpinner.isUserInteractionEnabled = true
        vaspsSpinner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
    }
    
    
    @objc func onClickEvent(sender:UITapGestureRecognizer){
        if(sender.view == vaspsSpinner){
            SpinnerSelector(self, vaspsSpinner, vasps!, 0, positionY: "UP").start()
        }
    }
    
    func onSelect(_ item: KycVo.SMAP, _ CATE: Int) {
        vaspsSpinner.text = item.key
        vaspSelected = item.value
        vaspCountry = item.temp
    }
    
    @IBAction func goNext(_ sender: Any) {
        if withdrawState {
            goHistory()
            return
        }
        if let v = vcTabWithdraw{
            if let error = errorCheck(){
                showErrorDialog(error)
                return
            }
            startOtp()
        }
    }
    
    fileprivate func goHistory(){
        vcTabWithdraw?.vcExchangeDetail?.goPage(2)
    }
    
    fileprivate func errorCheck() -> String?{
        let s1 = receiverEdit.text?.count
        if s1 == 0{
            return "받으실 분 성명을 입력하세요."
        }
        
        let s2 = addressEdit.text?.count
        if s2 == 0{
            return "받으실 분 계좌 주소를 입력하세요."
        }
        
        if vaspSelected.count == 0{
            return "받으실 거래소를 선택해 주세요."
        }
        return nil
    }
    
    func sendData(_ data:[String:Any?]){
        if let vasps = data["vasps"] as? Array<KycVo.SMAP>{
            self.vasps = vasps
        }
        if let d = data["feeText"] as? String{
            self.feeText = d
        }
        if let d = data["amountText"] as? String{
            self.amountText = d
        }
    }
    
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == receiverEdit){
            let scale = 30
            if receiverEdit.text?.count ?? 0 > scale{
                receiverEdit.text = (receiverEdit.text?.substring(from: 0, to: scale) ?? "")
            }
        }
        if(sender == addressEdit){
            let scale = 200
            if addressEdit.text?.count ?? 0 > scale{
                addressEdit.text = (addressEdit.text?.substring(from: 0, to: scale) ?? "")
            }
        }
        if(sender == destinationTagEdit){
            let scale = 200
            if destinationTagEdit.text?.count ?? 0 > scale{
                destinationTagEdit.text = (destinationTagEdit.text?.substring(from: 0, to: scale) ?? "")
            }
        }
    }
    
    fileprivate func startOtp(){
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "OtpDialog") as? OtpDialog else {
            return
        }
        vc.delegate = {[weak self] data in
            self?.confirmOtp(data)
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true);
    }
    
    fileprivate func confirmOtp(_ data:String){
        let request = WithdrawOtpAuthRequest()
        request.coinout_otp_number = data
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    fileprivate func checkLimit(){
        let request = CheckWithdrawLimitRequest()
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    fileprivate func withdraw(){
        let request = WithdrawRequest()
        request.coinType = vcTabWithdraw?.vcExchangeDetail?.coinCode
        request.request_amount = amountText!
        request.to_address = addressEdit.text!
        request.beneficiaryVaspId = vaspSelected
        if let country = vaspCountry{
            request.beneficiaryCountry = country
        }else{
            request.beneficiaryCountry = "kr"
        }
        request.beneficiaryName = receiverEdit.text!
        
        ApiFactory(apiResult: self, request: request).newThread()
        DispatchQueue.main.async{
            self.statusLayout.constant = self.statusLayoutValue
            self.statusText.text = ""
        }
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? CheckWithdrawLimitRequest{
            let response = CheckWithdrawLimitResponse(baseResponce: response)
            if let result = response.getResult(){
                if result == "limitKycDate"{
                    let s = "고객님의 안전한 거래이용을 위한 출금 정책에 따라 최초 가입 후 72시간 동안 출금 제한이 적용됩니다."
                    showErrorDialog(s)
                    return
                }
            }
            withdraw()
        }
        
        if let _ = response.request as? WithdrawOtpAuthRequest{
            let response = WithdrawOtpAuthResponse(baseResponce: response)
            if(response.getResult()){
                self.checkLimit()
            }else{
                self.showErrorDialog("OTP 번호가 일치하지 않습니다.")
            }
        }
        
        if let _ = response.request as? WithdrawRequest{
            let response = WithdrawResponse(baseResponce: response)
            if let code = response.getCode(){
                if code == "200"{
                    DispatchQueue.main.async{
                        self.statusText.text = "정상"
                        self.withdrawState = true
                        self.statusText.textColor = UIColor(named: "HogaPriceBlue")
                        self.nextBtn.setTitle("거래내역 보기", for: .normal)
                        guard let account = self.vcTabWithdraw?.vcExchangeDetail?.vcExchange?.accounts?[self.vcTabWithdraw?.vcExchangeDetail?.coinCode ?? "Nothing"] as? [String:Any] else {
                            return
                        }
                    }
                }else{
                    var s = "출금오류"
                    if code == "205"{
                        s = s + " - " + "거래비밀번호를 재입력해 주세요."
                    }else if code == "209"{
                        s = s + " - " + "출금 가능 수량을 확인해주세요."
                    }else if code == "210"{
                        s = s + " - " + "거래 비밀번호를 재입력해 주세요."
                    }else if code == "211"{
                        s = s + " - " + "로그인 후 이용해 주십시오."
                    }else if code == "213"{
                        s = s + " - " + "출금 준비 중인 코인입니다."
                    }else if code == "214"{
                        s = s + " - " + "출금 주소를 확인해 주세요."
                    }else if code == "216"{
                        s = s + " - " + "본인 주소로 출금 할 수 없습니다."
                    }else if code == "217"{
                        s = s + " - " + "1분 후에 다시 신청해 주세요."
                    }else if code == "218"{
                        DispatchQueue.main.async{
                            self.showErrorDialog("고객님의 계정이 피싱, 대출사기 등에 사용된 정황이 발견되어 거래 및 입출금을 일시적으로 중지하였습니다.")
                        }
                    }else if code == "219"{
                        DispatchQueue.main.async{
                            self.showErrorDialog("안전한 거래를 위해 입금자산 반영 후 최대 20분간 출금이 제한됩니다.")
                        }
                    }else{
                        if let msg = response.getMsg(){
                            s = s + " - " + msg
                        }
                    }
                    DispatchQueue.main.async{
                        self.statusText.text = s
                        self.statusText.textColor = UIColor(named: "HogaPriceRed")
                    }
                }
            }else{
                DispatchQueue.main.async{
                    self.statusText.text = "정상 처리되지 않았습니다."
                    self.statusText.textColor = UIColor(named: "HogaPriceRed")
                }
            }
            
        }
    }
}

//MARK: - Firebase
extension VCTabWithdrawStepTwo:FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        
        
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        
    }
    
    fileprivate func setValue(){
        if(feeText == nil || amountText == nil){return}
        let fee = DoubleDecimalUtils.newInstance(feeText!)
        let amount = DoubleDecimalUtils.newInstance(amountText!)
        let totalVolum = fee + amount
        
        amountPriceText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal:amount, scale: 8)))
        
        feePriceText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal:fee, scale: 8)))
        totalPriceText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal:totalVolum, scale: 8)))
        
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


extension VCTabWithdrawStepTwo: UITextFieldDelegate {
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(addressEdit == textField){
            addressBack.backgroundColor = UIColor(named: "HogaPriceBlue")
        }
        if(receiverEdit == textField){
            receiverBack.backgroundColor = UIColor(named: "HogaPriceBlue")
        }
        if(destinationTagEdit == textField){
            destinationBack.backgroundColor = UIColor(named: "HogaPriceBlue")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(addressEdit == textField){
            addressBack.backgroundColor = UIColor(named: "HogaPriceGray")
        }
        if(receiverEdit == textField){
            receiverBack.backgroundColor = UIColor(named: "HogaPriceGray")
        }
        if(destinationTagEdit == textField){
            destinationBack.backgroundColor = UIColor(named: "HogaPriceGray")
        }
    }
}
