//
//  VCTabHistory.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/18.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCTabHistory:VCBase {
    var vcExchangeDetail:VCExchangeDetail?
    
    var mArray:Array<FinanceHistroty> = Array<FinanceHistroty>()
    
    var startDate:Date?
    var endDate:Date?
    var exchangeType:String?
    var marketType:String?
    var coinCode:String?
    var pageNum:Int = 0
    
    @IBOutlet weak var startDateText: UILabel!
    @IBOutlet weak var endDateText: UILabel!
    @IBOutlet weak var coinNameText: UILabel!
    @IBOutlet weak var searchBtn: UIImageView!
    @IBOutlet weak var mList: UITableView!
    @IBOutlet weak var emptyText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitValue()
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        //mList.separatorStyle = .none
        visibleEmpty(true)
        
        searchBtn.isUserInteractionEnabled = true
        searchBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPopup)))
    }
    
    fileprivate func setInitValue(){
        startDate = Date()
        endDate = Date()
        exchangeType = "all"
        marketType = "all"
        coinCode = "all"
        pageNum = 0
        setDateText()
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
        mSpinner1.append(KycVo.SMAP(key: "모든 코인", value: "all"))
        mSpinner1.append(KycVo.SMAP(key: "BTC", value: "BTC"))
        if let list = vcExchangeDetail?.vcExchange?.coinList{
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
        mSpinner2.append(KycVo.SMAP(key: "입출금 전체", value: "all"))
        mSpinner2.append(KycVo.SMAP(key: "출금", value: "W"))
        mSpinner2.append(KycVo.SMAP(key: "입금", value: "D"))
        vc.mSpinner2 = mSpinner2
        
        
        vc.assetDelegate = {[weak self] coinCode, exchangeType, startDate, endDate in
            self?.endDate = endDate
            self?.startDate = startDate
            
            self?.exchangeType = exchangeType
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
    
    fileprivate func setDateText(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
    
        startDateText.text = formatter.string(from: startDate!)
        endDateText.text = formatter.string(from: endDate!)
        
        if(coinCode == "all"){
            coinNameText.text = ""
        }else{
            coinNameText.text = coinCode
        }
    }
    
    fileprivate func visibleEmpty(_ bool:Bool){
        if(bool){
            emptyText.text = "검색 결과가 없습니다."
        }else{
            emptyText.text = ""
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        getData()
    }
    
    fileprivate func getData(){
        pageNum += 1
        let request = WithdepHistoryRequest()
        request.page_no = String(pageNum)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    
        request.endExc = formatter.string(from: endDate!)
        request.startExc = formatter.string(from: startDate!)
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? WithdepHistoryRequest{
            let response = WithdepHistoryResponse(baseResponce: response)
            if let list = response.getListExc(){
                if(list.count == 0 && mArray.count == 0){
                    return
                }
                
                
                if let array = list as? Array<[String:Any]>{
                    for item in array{
                        let balance = toString(item["balance"])
                        let exc_margin_fee = toString(item["exc_margin_fee"])
                        let exc_real_fee = toString(item["exc_real_fee"])
                        let exc_state = toString(item["exc_state"])
                        let exc_total_fee = toString(item["exc_total_fee"])
                        let exc_type = toString(item["exc_type"])
                        let kr_name = toString(item["kr_name"])
                        let other_address = toString(item["other_address"])
                        let point_price = toString(item["point_price"])
                        let reg_date = toString(item["reg_date"])
                        let request_amount = toString(item["request_amount"])
                        let se_type = toString(item["se_type"])
                        
                        
                        let trade = FinanceHistroty(balance:balance, exc_margin_fee:exc_margin_fee, exc_real_fee:exc_real_fee, exc_state:exc_state, exc_total_fee:exc_total_fee, exc_type:exc_type, kr_name:kr_name, other_address:other_address,point_price:point_price, reg_date:reg_date, request_amount:request_amount,  se_type:se_type)
                        
                        if(exchangeType == "all"){
                            mArray.append(trade)
                        }else{
                            if(exchangeType == exc_type){
                                mArray.append(trade)
                            }else if(exchangeType == exc_type){
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
                    
                    if(mArray.count > 0 && mArray.count < response.getTotalCount()){
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
}


class FinanceHistoryCell:UITableViewCell{
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var feeText: UILabel!
    @IBOutlet weak var amountText: UILabel!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var moreHeight: NSLayoutConstraint!
    
}

struct FinanceHistroty{
    var balance:String?
    var exc_margin_fee:String?
    var exc_real_fee:String?
    var exc_state:String?
    var exc_total_fee:String?
    var exc_type:String?
    var kr_name:String?
    var other_address:String?
    var point_price:String?
    var reg_date:String?
    var request_amount:String?
    var se_type:String?
    var moreView = false
    var lastItem = false
    
    mutating func setMore(_ bool:Bool){
        self.moreView = bool
    }
    
    mutating func setLastItem(_ bool:Bool){
        self.lastItem = bool
    }
    
}

extension VCTabHistory: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceHistoryCell", for: indexPath) as? FinanceHistoryCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        if(mArray[indexPath.row].lastItem){
            mArray[indexPath.row].setLastItem(false)
            getData()
        }
        
        
        if let item = mArray[indexPath.row] as? FinanceHistroty{
            guard let state = item.exc_state else {return cell}
            guard let type = item.exc_type else {return cell}
                
            if type == "D"{
                cell.typeText.text = "입금"
                cell.typeText.textColor = UIColor(named: "CDA7569")
            }else if type == "W"{
                if state == "REF"{
                    cell.typeText.text = "환불"
                }else{
                    cell.typeText.text = "출금"
                }
                cell.typeText.textColor = UIColor(named: "C008CD6")
            }else{
                cell.typeText.text = "에어드랍"
                cell.typeText.textColor = UIColor(named: "C35B791")
            }
            
            if state == "ALY" || state == "ING"{
                cell.statusText.text = "진행중"
            }else if state == "REQ" || state == "RWAP_1" || state == "RWAP_2"{
                cell.statusText.text = "진행중"
            }else if state == "OK" {
                cell.statusText.text = "완료"
            }else if state == "REJ" || state == "BLK" {
                cell.statusText.text = "실패"
            }else if state == "REF" {
                cell.statusText.text = "완료"
            }else {
                cell.statusText.text = "실패"
            }
            
            cell.statusText.text = " : " + cell.statusText.text!
            
            if let requestAmount = item.request_amount{
                cell.amountText.text = CoinUtils.currency(requestAmount.replacingOccurrences(of: ",", with: "")) + " " + (item.se_type ?? "")
            }
            
            if let fee = item.exc_total_fee{
                cell.feeText.text = CoinUtils.currency(fee.replacingOccurrences(of: ",", with: "")) + " " + (item.se_type ?? "")
            }
            
            if let addr = item.other_address{
                cell.addressText.text = addr
            }
            
            if let date = item.reg_date{
                cell.dateText.text = date
            }
            
            if item.moreView{
                cell.moreHeight.constant = 25
                cell.moreImage.image = UIImage(named: "text_field_bottom_arrow")
            }else{
                cell.moreHeight.constant = 0
                cell.moreImage.image = UIImage(named: "text_field_top_arrow")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceHistoryCell", for: indexPath) as? FinanceHistoryCell else {
            return
        }
        if let item = mArray[indexPath.row] as? FinanceHistroty{
            if item.moreView{
                cell.moreHeight.constant = 0
                cell.moreImage.image = UIImage(named: "text_field_top_arrow")
            }else{
                cell.moreHeight.constant = 25
                cell.moreImage.image = UIImage(named: "text_field_bottom_arrow")
            }
            mArray[indexPath.row].setMore(!item.moreView)
            mList.reloadData()
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
        if let a = data as? Double{
            return String(a)
        }
        if let a = data as? Int64{
            return String(a)
        }
        
        if let date = data as? NSDictionary{
            if let time = date["time"] as? Int64{
                var dTime = Double(time) / 1000.0
                let d = Date(timeIntervalSince1970: dTime)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                return formatter.string(from: d)
            }
        }
        
        return ""
    }
}
