//
//  VCAssetRecord.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/09.
//

import Foundation
import UIKit
import Alamofire

class VCAssetRecord:VCBase{
    var vcAsset:VCAsset?
    var startDate:Date?
    var endDate:Date?
    var tradeType:String?
    var marketType:String?
    var coinCode:String?
    var pageNum:Int = 0
    
    var mArray:Array<TRADE> = Array<TRADE>()
    
    
    @IBOutlet weak var popupStartDateText: UILabel!
    @IBOutlet weak var popupEndDateText: UILabel!
    @IBOutlet weak var popupCoinCodeText: UILabel!
    @IBOutlet weak var popupSearchBtn: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var mList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setInitValue()
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        mList.separatorStyle = .none
        visibleEmpty(true)
        
        popupSearchBtn.isUserInteractionEnabled = true
        popupSearchBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPopup)))
    }
    
    @objc func showPopup(sender:UITapGestureRecognizer){
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "PopupSelect") as? PopupSelect else {
            return
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.startDate = startDate
        vc.endDate = endDate
        vc.mTitle = "거래내역 조건검색"
        
        var mSpinner1 = Array<KycVo.SMAP>()
        mSpinner1.append(KycVo.SMAP(key: "코인 전체", value: "all"))
        if let list = vcAsset?.coinList{
            for item in list{
                let market = toString(item["market_btc_status"])
                if market == "Y"{
                    let coinCode = toString(item["coin_code"]).uppercased()
                    mSpinner1.append(KycVo.SMAP(key: coinCode, value: coinCode))
                }
            }
        }
        vc.mSpinner1 = mSpinner1
        
        var mSpinner2 = Array<KycVo.SMAP>()
        mSpinner2.append(KycVo.SMAP(key: "거래 전체", value: "all"))
        mSpinner2.append(KycVo.SMAP(key: "매수", value: "B"))
        mSpinner2.append(KycVo.SMAP(key: "매도", value: "S"))
        vc.mSpinner2 = mSpinner2
        
        
        vc.assetDelegate = {[weak self] coinCode, tradeType, startDate, endDate in
            self?.endDate = endDate
            self?.startDate = startDate
            
            self?.tradeType = tradeType
            self?.coinCode = coinCode
            
            self?.pageNum = 0
            self?.mArray.removeAll()
            self?.mList.reloadData()
            self?.visibleEmpty(true)
            self?.setDateText()
            self?.getData()
        }
        self.present(vc, animated: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        getData()
    }
    
    fileprivate func setInitValue(){
        startDate = Date()
        endDate = Date()
        tradeType = "all"
        marketType = "all"
        coinCode = "all"
        pageNum = 0
        setDateText()
    }
    
    fileprivate func setDateText(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
    
        popupStartDateText.text = formatter.string(from: startDate!)
        popupEndDateText.text = formatter.string(from: endDate!)
        
        if(coinCode == "all"){
            popupCoinCodeText.text = ""
        }else{
            popupCoinCodeText.text = coinCode
        }
    }
    
    fileprivate func getData(){
        pageNum += 1
        let request = SearchTradeListRequest()
        request.page_no = String(pageNum)
        request.coin_code = coinCode
        if let tradeType = request.trd_type{
            if(tradeType != "all"){
                request.trd_type = tradeType
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    
        request.endDate = formatter.string(from: endDate!)
        request.startDate = formatter.string(from: startDate!)
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? SearchTradeListRequest{
            let response = SearchTradeListResponse(baseResponce: response)
            if let list = response.getListTrd(){
                if(list.count == 0 && mArray.count == 0){
                    return
                }
                
                
                if let array = list as? Array<[String:Any]>{
                    for item in array{
                        let regDate = toString(item["reg_date"])
                        let fee = toDouble(item["fee"])
                        let coinCode = toString(item["coin_code"])
                        let marketCode = toString(item["market_code"])
                        let feeType = toString(item["fee_type"])
                        let trdType = toString(item["trd_type"])
                        let coinQty = toDouble(item["coin_qty"])
                        let coinPrice = toDouble(item["coin_price"])
                        
                        let trade = TRADE(regDate:regDate, fee:fee, coinCode:coinCode, marketCode:marketCode, feeType:feeType, trdType:trdType, coinQty:coinQty, coinPrice:coinPrice, lastItem:false)
                        
                        if(tradeType == "all"){
                            mArray.append(trade)
                        }else{
                            if(tradeType == trdType){
                                mArray.append(trade)
                            }else if(tradeType == trdType){
                                mArray.append(trade)
                            }
                        }
                    }
                    
                    if(mArray.count > 0){
                        DispatchQueue.main.async{
                            self.visibleEmpty(false)
                            self.mList.reloadData()
                            if(response.getPageNo() == 1){
                                self.mList.setContentOffset(CGPoint.zero, animated: false)
                            }
                            
                        }
                    }
                    
                    if(self.pageNum < response.getFinalPageNo()){
                        mArray[mArray.count - 1].setLastItem(true)
                    }
                    
                    
                }
            }
        }
    }
    override func onError(e: AFError, method: String) {
        print(e)
        print(method)
    }
    
    fileprivate func visibleEmpty(_ bool:Bool){
        if(bool){
            scrollView.isHidden = true
        }else{
            scrollView.isHidden = false
        }
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


//MARK: - TableView
class AssetRecodeCell: UITableViewCell{
    @IBOutlet weak var regDate: UILabel!
    @IBOutlet weak var coinMarket: UILabel!
    @IBOutlet weak var recordPrice: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var trdType: UILabel!
    @IBOutlet weak var trdAmount: UILabel!
    @IBOutlet weak var trdVolume: UILabel!
    @IBOutlet weak var settlementVolume: UILabel!
}

struct TRADE{
    var regDate:String?
    var fee:Double?
    var coinCode:String?
    var marketCode:String?
    var feeType:String?
    var trdType:String?
    var coinQty:Double?
    var coinPrice:Double?
    var lastItem = false
    
    mutating func setLastItem(_ bool:Bool){
        self.lastItem = bool
    }
}

extension VCAssetRecord: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssetRecodeCell", for: indexPath) as? AssetRecodeCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        
        if(mArray[indexPath.row].lastItem){
            mArray[indexPath.row].setLastItem(false)
            getData()
        }
        
        
        if let item = mArray[indexPath.row] as? TRADE{
            cell.regDate.text = ""
            cell.coinMarket.text = ""
            cell.recordPrice.text = ""
            cell.fee.text = ""
            cell.trdType.text = ""
            cell.trdAmount.text = ""
            cell.trdVolume.text = ""
            cell.settlementVolume.text = ""
            
            if let date = item.regDate{
                cell.regDate.text = date.components(separatedBy: ".")[0]
            }
            
            cell.coinMarket.text = (item.coinCode ?? "") + "/" + (item.marketCode ?? "")
            
            var krw_real:Double = 0
            var fee = DoubleDecimalUtils.setMaximumFractionDigits(item.fee!, scale: 8)
            
            if let feeType = item.feeType{
                if(feeType == "K" || feeType == "k"){
                    krw_real = (item.coinQty! * item.coinPrice!) - item.fee!
                    fee = DoubleDecimalUtils.setMaximumFractionDigits(item.fee!, scale: 0) + " " + item.marketCode!
                }else if(feeType == "C" || feeType == "c"){
                    krw_real = (item.coinQty! * item.coinPrice!)
                    fee = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(item.fee!, scale: 8))
                    fee = fee + " " + item.marketCode!
                }
            }
            
            if let market = item.marketCode{
                if market == "all"{
                    cell.recordPrice.text = CoinUtils.toFixed(item.coinPrice!, 2) + " " + item.marketCode!
                }else{
                    cell.recordPrice.text = CoinUtils.toFixed(item.coinPrice!, 8) + " " + item.marketCode!
                }
            }
            
            cell.fee.text = fee
            
            if(item.trdType! == "S"){
                cell.trdType.text = "매도"
                cell.trdType.textColor = UIColor(named: "HogaPriceBlue")
            }else{
                cell.trdType.text = "매수"
                cell.trdType.textColor = UIColor(named: "HogaPriceRed")
            }
            
            cell.trdAmount.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(item.coinQty!))) + " " + item.coinCode!
            
            if let market = item.marketCode{
                if market == "all" {
                    cell.trdVolume.text = CoinUtils.currency(String(item.coinPrice! * item.coinQty!)) + " " + item.marketCode!
                    cell.settlementVolume.text = CoinUtils.currency(String(krw_real)) + " " + item.marketCode!
                }else{
                    cell.trdVolume.text = CoinUtils.currency(CoinUtils.toFixed(item.coinPrice! * item.coinQty!, 8)) + " " + item.marketCode!
                    cell.settlementVolume.text = CoinUtils.currency(CoinUtils.toFixed(krw_real, 8)) + " " + item.marketCode!
                }
            }
            
        }
        
        
        
        return cell
    }
}
