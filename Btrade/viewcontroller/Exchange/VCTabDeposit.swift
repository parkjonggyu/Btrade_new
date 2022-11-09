//
//  VCTabDeposit.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/18.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCTabDeposit:VCBase {
    var vcExchangeDetail:VCExchangeDetail?
    
    
    @IBOutlet weak var inActiveLayout: UIStackView!
    @IBOutlet weak var activeLayout: UIStackView!
    
    @IBOutlet weak var subTitleText: UILabel!
    @IBOutlet weak var makeBtn: UIButton!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var addr1Border: UIView!
    @IBOutlet weak var addr1Text: UILabel!
    @IBOutlet weak var addr1Btn: UILabel!
    
    @IBOutlet weak var addr2Border: UIView!
    
    @IBOutlet weak var addr2Layout: UIView!
    @IBOutlet weak var addr2Btn: UIView!
    @IBOutlet weak var addr2Visible: NSLayoutConstraint!
    @IBOutlet weak var addr2Text: UILabel!
    @IBOutlet weak var noticeText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }
    
    fileprivate func initLayout(){
        addr1Text.text = ""
        addr2Text.text = ""
        addr1Border.layer.cornerRadius = 10
        addr1Border.layer.borderWidth = 1
        addr1Border.layer.borderColor = UIColor(named: "HogaPriceBlue")?.cgColor
        addr2Border.layer.cornerRadius = 10
        addr2Border.layer.borderWidth = 1
        addr2Border.layer.borderColor = UIColor(named: "HogaPriceBlue")?.cgColor
        addr2Layout.layer.isHidden = true
        
        makeBtn.isUserInteractionEnabled = true
        makeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
        addr1Btn.isUserInteractionEnabled = true
        addr1Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
        addr2Btn.isUserInteractionEnabled = true
        addr2Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
    }
    
    fileprivate func setValue(){
        noticeText.text = "◆ 위 주소는 " + (vcExchangeDetail?.coinCode ?? "BTC") + "만 입금할 수 있습니다."
        subTitleText.text = (vcExchangeDetail?.coinCode ?? "BTC") + " 입금 하실 수 있습니다."
        
        if let account = vcExchangeDetail?.vcExchange?.accounts?[vcExchangeDetail?.coinCode ?? "E"] as? [String:Any] {
            if let addr = account["address"] as? String{
                if(addr != ""){
                    visibleLayout(true)
                    addr1Text.text = addr
                    makeQRCodeImage(addr)
                }else{
                    visibleLayout(false)
                }
            }else{
                visibleLayout(false)
            }
        }
    }
    
    fileprivate func makeQRCodeImage(_ s: String){
        let url = s
        let data = url.data(using: .utf8)
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage" : data, "inputCorrectionLevel" : "M"])
        let sizeTransform = CGAffineTransform(scaleX: 5, y: 5)
        qrCodeImage.image = UIImage(ciImage: (qr?.outputImage!.transformed(by: sizeTransform))!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setValue()
    }
    
    fileprivate func visibleLayout(_ bool:Bool){
        activeLayout.isHidden = !bool
        inActiveLayout.isHidden = bool
    }
    
    @objc func onClickEvent(sender:UITapGestureRecognizer){
        if(sender.view == makeBtn){
            createDeposit()
        }else if(sender.view == addr1Btn){
            if addr1Text.text != nil && addr1Text.text!.count > 0{
                UIPasteboard.general.string = addr1Text.text!
                showToast("주소키가 복사 되었습니다.")
            }
        }else if(sender.view == addr2Btn){
            if addr2Text.text != nil && addr2Text.text!.count > 0{
                UIPasteboard.general.string = addr2Text.text!
                showToast("주소키가 복사 되었습니다.")
            }
        }
    }
    
}

//MARK: - makrQRCode
extension VCTabDeposit{
    fileprivate func createDeposit(){
        let request = CreateAccountRequest()
        request.coinType = vcExchangeDetail?.coinCode ?? "ETH"
        ApiFactory(apiResult: CreateAccount(self), request: request).newThread()
    }
    
    class CreateAccount:ApiResult{
        var vcTabDeposit:VCTabDeposit
        init(_ vc:VCTabDeposit){
            self.vcTabDeposit = vc
        }
        
        func onResult(response: BaseResponse) {
            if let _ = response.request as? CreateAccountRequest{
                let response = CreateAccountResponse(baseResponce: response)
                
                if let code = response.getCode(){
                    if(code == "9999"){
                        DispatchQueue.main.async{
                            self.vcTabDeposit.showErrorDialog("계좌를 생성하지 못했습니다.")
                        }
                        return
                    }
                }
                
                if let map = response.getMap(){
                    if(map == "NOT_CERTIFIED" || map == "0"){
                        DispatchQueue.main.async{
                            self.vcTabDeposit.showErrorDialog("계좌를 생성하지 못했습니다.")
                        }
                        return
                    }
                }
                
                if let account = response.getAccount(){
                    self.vcTabDeposit.vcExchangeDetail?.vcExchange?.accounts?[self.vcTabDeposit.vcExchangeDetail?.coinCode ?? "A"] = account
                    self.vcTabDeposit.setValue()
                }
            }
        }
        
        func onError(e: AFError, method: String) {}
        
        
    }
}
