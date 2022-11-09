//
//  VCTabCSDeposit.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/25.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCTabCSDeposit:VCBase {
   
     var vcExchangeDetail:VCExchangeDetail?

    var mArray:Array<CSDeposit> = Array<CSDeposit>()

    var startDate:Date?
    var endDate:Date?
    var status:String?
    var coinCode:String?
    var pageNum:Int = 0

    @IBOutlet weak var startDateText: UILabel!
    @IBOutlet weak var endDateText: UILabel!
    @IBOutlet weak var coinNameText: UILabel!
    @IBOutlet weak var searchBtn: UIImageView!
    @IBOutlet weak var mList: UITableView!
    @IBOutlet weak var emptyText: UILabel!
    var footerView:CSDepositFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadFooterView()
        
        setInitValue()
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        //mList.separatorStyle = .none
        visibleEmpty(true)
        
        searchBtn.isUserInteractionEnabled = true
        searchBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPopup)))
    }
    
    fileprivate func loadFooterView(){
        if let v = Bundle.main.loadNibNamed("CSDepositView", owner: nil, options: nil)?.first as? CSDepositFooterView{
            footerView = v
        }
    }
    
    fileprivate func setInitValue(){
        startDate = Date()
        endDate = Date()
        status = "ALL"
        coinCode = "ALL"
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
        vc.mTitle = "검색조건 입력"
        
        var mSpinner1 = Array<KycVo.SMAP>()
        mSpinner1.append(KycVo.SMAP(key: "모든 코인", value: "ALL"))
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
        mSpinner2.append(KycVo.SMAP(key: "모두보기", value: "ALL"))
        mSpinner2.append(KycVo.SMAP(key: "입금대기", value: "R"))
        mSpinner2.append(KycVo.SMAP(key: "증빙요청", value: "A"))
        mSpinner2.append(KycVo.SMAP(key: "증빙수신", value: "V"))
        mSpinner2.append(KycVo.SMAP(key: "증빙지연", value: "D"))
        mSpinner2.append(KycVo.SMAP(key: "반환완료", value: "P"))
        vc.mSpinner2 = mSpinner2
        
        
        vc.assetDelegate = {[weak self] coinCode, status, startDate, endDate in
            self?.endDate = endDate
            self?.startDate = startDate
            
            self?.coinCode = coinCode
            self?.status = status
            
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
        
        if(coinCode == "ALL"){
            coinNameText.text = ""
        }else{
            coinNameText.text = coinCode
        }
    }
    
    fileprivate func visibleEmpty(_ bool:Bool){
        if(bool){
            emptyText.text = "검색 결과가 없습니다."
            mList.tableFooterView = nil
        }else{
            emptyText.text = ""
            mList.tableFooterView = footerView
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        getData()
    }
    
    fileprivate func getData(){
        pageNum += 1
        let request = CsDepositRequest()
        request.page_no = String(pageNum)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    
        request.endExc = formatter.string(from: endDate!)
        request.startExc = formatter.string(from: startDate!)
        request.coin_code = coinCode
        request.csstatus = status
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? CsDepositRequest{
            let response = WithdepHistoryResponse(baseResponce: response)
            if let list = response.getListExc(){
                if(list.count == 0 && mArray.count == 0){
                    return
                }
                
                
                if let array = list as? Array<[String:Any]>{
                    var tempArray = Array<CSDeposit>()
                    for item in array{
                        let coin_symbol = toString(item["coin_symbol"])
                        let amount = toString(item["amount"])
                        let status = toString(item["status"])
                        let deposit_date = toString(item["deposit_date"])
                        let to_address = toString(item["to_address"])
                        
                        let trade = CSDeposit(coin_symbol:coin_symbol, amount:amount, status:status, deposit_date:deposit_date, to_address:to_address)
                        
                        if(coinCode == "ALL"){
                            mArray.append(trade)
                        }else if(coinCode == coin_symbol){
                            mArray.append(trade)
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


class CSDepositCell:UITableViewCell{
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var amountText: UILabel!
}

struct CSDeposit{
    var coin_symbol:String?
    var amount:String?
    var status:String?
    var deposit_date:String?
    var to_address:String?
    var lastItem = false
    
    mutating func setLastItem(_ bool:Bool){
        self.lastItem = bool
    }
    
}

extension VCTabCSDeposit: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CSDepositCell", for: indexPath) as? CSDepositCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        if(mArray[indexPath.row].lastItem){
            mArray[indexPath.row].setLastItem(false)
            getData()
        }
        

        if let item = mArray[indexPath.row] as? CSDeposit{
            
            
            if let requestAmount = item.amount{
                let amount = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: DoubleDecimalUtils.newInstance(requestAmount), scale: 8))
                cell.amountText.text = DoubleDecimalUtils.removeLastZero(amount) + " " + (item.coin_symbol ?? "")
            }
            
            if let addr = item.to_address{
                cell.addressText.text = addr
            }
            
            if let date = item.deposit_date{
                cell.dateText.text = date
            }
            
            if let status = item.status{
                if status == "R"{
                    cell.typeText.text = "입금대기"
                }else if status == "A"{
                    cell.typeText.text = "증빙요청"
                }else if status == "V"{
                    cell.typeText.text = "증빙수신"
                }else if status == "D"{
                    cell.typeText.text = "증빙지연"
                }else if status == "P"{
                    cell.typeText.text = "반환완료"
                }
                
            }
        }
        return cell
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

class CSDepositFooterView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
}

