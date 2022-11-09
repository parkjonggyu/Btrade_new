//
//  VCAsset.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/09.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCExchange:VCBase, FirebaseInterface, ValueEventListener{
    
    var statusUpdate = true;
    
    @IBOutlet weak var totalLayout: UIView!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var totalAssetText: UILabel!
    @IBOutlet weak var mList: UITableView!
    
    @IBOutlet weak var check1Image: UIImageView!
    @IBOutlet weak var check1Text: UILabel!
    @IBOutlet weak var check2Image: UIImageView!
    @IBOutlet weak var check2Text: UILabel!
    var check1 = false
    var check2 = false
    
    
    var marketList:Array<[String:Any]>?
    var coinList:Array<[String:Any]>?
    var coinBalance:Array<[String:Any]>?
    var accounts:[String:Any]?
    var addressListObject:Array<[String:Any]>?
    var symbolsObject:Array<String>?
    var addressByState:[String:Any]?
    var listData:Array<[String:Any]>?
    var mALLArray:Array<Finance> = Array<Finance>()
    var mArray:Array<Finance> = Array<Finance>()
    var totalAsset:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        mList.separatorStyle = .none
        
        initLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appInfo.setBtcInterface(nil)
        appInfo.setKrwInterface(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(statusUpdate){
            statusUpdate = false
            getData()
        }
        appInfo.setBtcInterface(self)
        appInfo.setKrwInterface(self)
    }
    
    func onDataChange(market: String) {}
    
    func onDataChange(snapshot: DataSnapshot) {
        if(mArray.count > 0){mList.reloadData()}
    }
    
    fileprivate func initLayout(){
        totalLayout.layer.cornerRadius = 3
        
        searchText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        searchText.borderStyle = .none
        searchText.text = ""
        
        check1 = false
        check1 = false
        check1Image.image = UIImage(named: "check_inactive")
        check2Image.image = UIImage(named: "check_inactive")
        check1Image.isUserInteractionEnabled = true
        check1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickCheck)))
        check1Text.isUserInteractionEnabled = true
        check1Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickCheck)))
        check2Image.isUserInteractionEnabled = true
        check2Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickCheck)))
        check2Text.isUserInteractionEnabled = true
        check2Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickCheck)))
    }
    
    fileprivate func getData(){
        totalAsset = 0
        mALLArray.removeAll()
        mArray.removeAll()
        coinBalance = nil
        listData = nil
        getSubData()
        ApiFactory(apiResult: self, request: BalanceRequest()).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? BalanceRequest{
            let response = BalanceResponse(baseResponce: response)
            if let a = response.getCoinBalance(){
                coinBalance = a
            }
            
            if let a = response.getAddressList(){
                addressListObject = a
            }
            
            if let a = response.getSymbols(){
                symbolsObject = a
            }
            
            if let a = response.getAddressByState(){
                addressByState = a
            }
            makeList()
        }
    }
    
    fileprivate func makeList(){
        guard let _ = coinBalance , let _ = listData else{return}
        
        
        for balance in coinBalance!{
            for item in listData!{
                let coin1 = toString(balance["coin_code"])
                let coin2 = toString(item["simple_form"])
                if(coin1 == coin2){
                    var finance = Finance(btcBalance: toDouble(balance["balance"]) * toDouble(balance["now_price"]), localBlnc: toDouble(balance["balance"]), nowPrice: toDouble(balance["now_price"]), marketStatus: toString(balance["market_btc_status"]), marketHupStatus: toString(balance["market_hup_status"]), coinCode: toString(balance["coin_code"]), coinName: toString(balance["coin_name"]), coinGroup: toString(item["coin_grooup"]) )
                    if(coin1 == "BTC"){
                        finance.setBtcBalance(finance.localBlnc)
                    }
                    mALLArray.append(finance)
                    totalAsset += finance.btcBalance!
                    break
                }
            }
        }
        DispatchQueue.main.async{
            self.totalAssetText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(self.totalAsset, scale: 8)) + " BTC"
            self.sortList()
        }
    }
}

//MARK: - Sort List
extension VCExchange{
    @objc func textFieldDidChange(_ sender: UITextField?) {
        if(sender == searchText){
            sortList()
        }
    }
    
    @objc func clickCheck(sender:UITapGestureRecognizer){
        if(sender.view == check1Image || sender.view == check1Text){
            check1 = !check1
            changeImage(check1, check1Image)
        }else if(sender.view == check2Image || sender.view == check2Text){
            check2 = !check2
            changeImage(check2, check2Image)
        }
    }
    
    fileprivate func changeImage(_ bool:Bool,_ imageView:UIImageView){
        if(bool){
            imageView.image = UIImage(named: "check_active")
        }else{
            imageView.image = UIImage(named: "check_inactive")
        }
        sortList()
    }
    
    fileprivate func sortList(){
        if mALLArray == nil || mALLArray.count == 0 {return}
        mArray = mALLArray
        
        if(check1){
            var temp:Array<Finance> = Array<Finance>()
            for item in mArray{
                if item.localBlnc! > 0{
                    temp.append(item)
                }
            }
            mArray = temp
        }
        
        if(check2){
            mArray = mArray.sorted(by: { f1, f2 in
                return f1.localBlnc! > f2.localBlnc!
            })
        }
        
        let text = searchText.text!.lowercased()
        if text != "" {
            var temp:Array<Finance> = Array<Finance>()
            for item in mArray{
                if (item.coinCode?.lowercased().contains(text)) ?? false {
                    temp.append(item)
                }else if (item.coinName?.lowercased().contains(text)) ?? false {
                    temp.append(item)
                }
            }
            mArray = temp
        }
        
        mList.reloadData()
    }
}


//MARK: - TableView
extension VCExchange: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCell", for: indexPath) as? FinanceCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        cell.coinNameText.text = ""
        cell.coinPriceText.text = "0"
        cell.coinCodeText.text = ""
        cell.krwPriceText.text = "0 KRW"
        
        if let item = mArray[indexPath.row] as? Finance{
            let krw = appInfo.krwValue! * DoubleDecimalUtils.newInstance(item.btcBalance)
            cell.krwPriceText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: krw, scale: 0)) + " KRW"
            
            if(item.marketStatus == "Y" || item.marketHupStatus == "Y" || item.coinCode == "BTC"){
                cell.coinCodeText.text = item.coinCode
                cell.coinPriceText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(item.localBlnc!, scale: 8)))
            }
            cell.coinNameText.text = item.coinName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = mArray[indexPath.row] as? Finance{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCExchangeDetail") as? VCExchangeDetail else {
                return
            }
            vc.vcExchange = self
            vc.coinCode = item.coinCode
            vc.coinName = item.coinName
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true);
        }
    }
}

class FinanceCell: UITableViewCell{
    @IBOutlet weak var coinNameText: UILabel!
    @IBOutlet weak var coinPriceText: UILabel!
    @IBOutlet weak var coinCodeText: UILabel!
    @IBOutlet weak var krwPriceText: UILabel!
}



//MARK: - ApiFactory
extension VCExchange{
    fileprivate func getSubData(){
        ApiFactory(apiResult: SubData(self), request: HoldingsRequest()).newThread()
        ApiFactory(apiResult: SubData(self), request: AllAccountRequest()).newThread()
        ApiFactory(apiResult: SubData(self), request: ServiceCoinRequest()).newThread()
    }
    
    class SubData:ApiResult{
        let v:VCExchange?
        init(_ v:VCExchange){
            self.v = v
        }
        func onResult(response: BaseResponse) {
            if let _ = response.request as? HoldingsRequest{
                let response = HoldingsResponse(baseResponce: response)
                if let json = response.getMarketist(){
                    var a:NSArray?
                    do{
                        a = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? NSArray
                        v?.marketList = (a as! Array<[String:Any]>)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                
                if let json = response.getCoinList(){
                    var b:NSArray?
                    do{
                        b = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? NSArray
                        v?.coinList = (b as! Array<[String:Any]>)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
            if let _ = response.request as? ServiceCoinRequest{
                let response = ServiceCoinResponse(baseResponce: response)
                if let l = response.getList(){
                    v?.listData = l
                }
                v?.makeList()
            }
            
            if let _ = response.request as? AllAccountRequest{
                let response = AllAccountResponse(baseResponce: response)
                if let l = response.getAccount(){
                    v?.accounts = l
                }
            }
        }
        
        func onError(e: AFError, method: String) {}
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

struct Finance{
    var btcBalance:Double?
    var localBlnc:Double?
    var nowPrice:Double?
    var marketStatus:String?
    var marketHupStatus:String?
    var coinCode:String?
    var coinName:String?
    var coinGroup:String?
    
    mutating func setBtcBalance(_ d:Double?){
        btcBalance = d
    }
}
