//
//  VCAssetStatus.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/09.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCAssetStatus:VCBase{
    var vcAsset:VCAsset?
    var totalValuationAmount:Decimal = Decimal(0)
    var totalBuyAmount:Decimal = Decimal(0)
    var totalProfit = Decimal(0)
    var mArray:Array<ASSET> = Array<ASSET>()
    var assetHeader:AssetHeader?
    var assetHeaderView:AssetHeaderView?
    
    @IBOutlet weak var mList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadHeaderView()
        
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        mList.separatorStyle = .none
        if let _ = assetHeaderView{
            assetHeaderView?.bacLayout.layer.cornerRadius = 20
            assetHeaderView?.totalBtcText.text = "0"
            assetHeaderView?.totalKrwText.text = "0"
            assetHeaderView?.tradeCanBtcText.text = "0"
            assetHeaderView?.tradeCanKrwText.text = "0"
            assetHeaderView?.totalProfitKrwText.text = "0"
            assetHeaderView?.totalProfitPerText.text = "0.00"
            
            assetHeaderView?.sortBtn1.isUserInteractionEnabled = true
            assetHeaderView?.sortBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sort)))
            assetHeaderView?.sortBtn2.isUserInteractionEnabled = true
            assetHeaderView?.sortBtn2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sort)))
            
            mList.tableHeaderView = assetHeaderView
        }
    }
    
    @objc func sort(sender:UITapGestureRecognizer){
        if let a = assetHeaderView{
            if(a.sort){
                a.sort = false
                mArray = Array<ASSET>(a.oldArray)
                a.sortBtn1.image = UIImage(named: "check_inactive")
            }else{
                a.sort = true
                a.oldArray = Array<ASSET>(mArray)
                mArray.sort { item1, item2 in
                    return DoubleDecimalUtils.doubleValue(item1.balance) ?? 0 > DoubleDecimalUtils.doubleValue(item2.balance) ?? 0
                }
                a.sortBtn1.image = UIImage(named: "check_active")
            }
            if(mArray.count > 0){mList.reloadData()}
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let b = vcAsset?.statusUpdate{
            if(b){
                vcAsset?.statusUpdate = false
                getData()
            }
        }
        if(vcAsset != nil){vcAsset?.setInterface(self)}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(vcAsset != nil){vcAsset?.setInterface(nil)}
    }
    
    
    fileprivate func getData(){
        totalValuationAmount = Decimal(0)
        totalBuyAmount = Decimal(0)
        totalProfit = Decimal(0)
        mArray.removeAll()
        ApiFactory(apiResult: self, request: HoldingsRequest()).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? HoldingsRequest{
            let response = HoldingsResponse(baseResponce: response)
            if let json = response.getMarketist(){
                var marketList:NSArray?
                do{
                    marketList = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? NSArray
                    vcAsset?.marketList = marketList as! Array
                    print(type(of: marketList))
                }catch{
                    print(error.localizedDescription)
                }
            }
            
            if let json = response.getCoinList(){
                var coinList:NSArray?
                do{
                    coinList = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? NSArray
                    vcAsset?.coinList = coinList as! Array
                }catch{
                    print(error.localizedDescription)
                }
            }
            
            
            if let json = response.getJson_coin_balance(){
                var a:NSArray?
                do{
                    a = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? NSArray
                    if let array = a as? Array<[String:Any]>{
                        var total:Decimal = Decimal(0)
                        var totalBtc:Decimal = Decimal(0)
                        
                        for item in array{
                            let coin_name = toString(item["coin_name"])
                            let coin_code = toString(item["coin_code"])
                            let balance = DoubleDecimalUtils.newInstance(toDouble(item["balance"]))
                            let trade_can = DoubleDecimalUtils.newInstance(toDouble(item["trade_can"]))
                            let now_price = DoubleDecimalUtils.newInstance(toDouble(item["now_price"]))
                            let avg_coin_price = DoubleDecimalUtils.newInstance(toDouble(item["avg_coin_price"]))
                            if(balance > 0){
                                if(coin_code == "BTC"){
                                    total += balance
                                    totalBtc += trade_can
                                }else{
                                    total +=  (balance * now_price)
                                    
                                    totalValuationAmount +=  (balance * now_price)
                                    totalBuyAmount += (balance * avg_coin_price)
                                    mArray.append(ASSET(coin_name: coin_name, coin_code: coin_code, balance: balance, now_price: now_price, trade_can: trade_can, avg_coin_price: avg_coin_price))
                                }
                                
                            }
                        }
                        print("totalValuationAmount : " , totalValuationAmount)
                        print("totalBuyAmount : " , totalBuyAmount)
                         
                        totalProfit = totalValuationAmount - totalBuyAmount
                        print("totalProfit : " , totalProfit)
                        
                        
                        assetHeader = AssetHeader(total:total, totalBtc:totalBtc)
                        DispatchQueue.main.async{
                            self.reloadData()
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func onError(e: AFError, method: String) {}
    
    
}

//MARK: - Firebase
extension VCAssetStatus: FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {}
    func onDataChange(snapshot: DataSnapshot) {
        DispatchQueue.main.async{
            self.calcKrwData()
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
    
    fileprivate func calcKrwData(){
        if let v = assetHeaderView, let d = assetHeader{
            if let _ = appInfo.krwValue{
                v.totalKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: d.total! * appInfo.krwValue!, scale: 0))
                v.tradeCanKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: d.totalBtc! * appInfo.krwValue!, scale: 0))
                v.totalProfitKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: totalProfit * appInfo.krwValue!, scale: 0))
            }
        }
        if(mArray.count > 0){mList.reloadData()}
    }
}

struct ASSET{
    var coin_name:String?
    var coin_code:String?
    var balance:Decimal?
    var now_price:Decimal?
    var trade_can:Decimal?
    var avg_coin_price:Decimal?
}


//MARK - Header View
struct AssetHeader{
    var total:Decimal?
    var totalBtc:Decimal?
}

extension VCAssetStatus{
    fileprivate func loadHeaderView(){
        if let v = Bundle.main.loadNibNamed("AssetHeaderView", owner: nil, options: nil)?.first as? AssetHeaderView{
            assetHeaderView = v
        }
    }
}

class AssetHeaderView:UIView{
    
    @IBOutlet weak var bacLayout: UIView!
    @IBOutlet weak var totalBtcText: UILabel!
    @IBOutlet weak var totalKrwText: UILabel!
    
    @IBOutlet weak var tradeCanBtcText: UILabel!
    @IBOutlet weak var tradeCanKrwText: UILabel!
    
    @IBOutlet weak var totalProfitKrwText: UILabel!
    @IBOutlet weak var totalProfitPerText: UILabel!
    
    @IBOutlet weak var sortBtn1: UIImageView!
    @IBOutlet weak var sortBtn2: UILabel!
    
    var oldArray:Array<ASSET> = Array<ASSET>()
    var sort = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
}


//MARK: - TableView
class AssetCell: UITableViewCell{
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var price1Text: UILabel! //profitTextView 평가 손익
    @IBOutlet weak var price2Text: UILabel! //profitPercentageTextView 수익률
    @IBOutlet weak var price3Text: UILabel! //balance. 보유수량
    @IBOutlet weak var price4Text: UILabel! //valuationAmount 평가금액
    @IBOutlet weak var price5Text: UILabel! //valuationAmountkrw 한화 평가금액
    @IBOutlet weak var price6Text: UILabel! // 매수금액
    @IBOutlet weak var price7Text: UILabel! // 한화 매수금액
    @IBOutlet weak var price8Text: UILabel! // 매수 평균가
    
    @IBOutlet weak var coinText: UILabel!
    @IBOutlet weak var market1Text: UILabel!
    @IBOutlet weak var market2Text: UILabel!
    
    
    var goDetailDelegate:DetailDelegate?
    func setBtnDelegate(_ idx:Int,_ delegate:DetailDelegate){
        goDetailDelegate = delegate
        titleText.tag = idx
        titleText.isUserInteractionEnabled = true
        titleText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goDetailBtn)))
    }
    
    @objc func goDetailBtn(sender:UITapGestureRecognizer){
        if(sender.view == titleText){
            if let i = sender.view?.tag{
                goDetailDelegate?.goDetailBntClick(i)
            }
        }
    }
}


extension VCAssetStatus:DetailDelegate{
    func goDetailBntClick(_ idx:Int) {
        goDetail(idx)
    }
    
    fileprivate func goDetail(_ idx:Int){
        if let item = mArray[idx] as? ASSET{
            if let coin = appInfo.getCoinList(item.coin_code!){
                let sb = UIStoryboard.init(name:"Trade", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: "tradedetailvc") as? VCCoinDetail else {
                    return
                }
                VCCoinDetail.coin = coin
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true);
            }
        }
    }
}

protocol DetailDelegate{
    func goDetailBntClick(_ idx:Int)
}


extension VCAssetStatus: UITableViewDataSource, UITableViewDelegate {
    func reloadData(){
        if let v = assetHeaderView, let d = assetHeader{
            v.totalBtcText.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: d.total!, scale: 8))
            v.tradeCanBtcText.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: d.totalBtc!, scale: 8))
            
            let per = (totalProfit / totalBuyAmount) * Decimal(100)
            
            v.totalProfitPerText.text = DoubleDecimalUtils.setMaximumFractionDigits(decimal: per, scale: 2)
        }
        calcKrwData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath) as? AssetCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        
//        @IBOutlet weak var price1Text: UILabel! //profitTextView 평가 손익
//        @IBOutlet weak var price2Text: UILabel! //profitPercentageTextView 수익률
//        @IBOutlet weak var price3Text: UILabel! //balance. 보유수량
//        @IBOutlet weak var price4Text: UILabel! //valuationAmount 평가금액
//        @IBOutlet weak var price5Text: UILabel! //valuationAmountkrw 한화 평가금액
//        @IBOutlet weak var price6Text: UILabel! // 매수금액
//        @IBOutlet weak var price7Text: UILabel! // 한화 매수금액
//        @IBOutlet weak var price8Text: UILabel! // 매수 평균가
        
        if let item = mArray[indexPath.row] as? ASSET{
            cell.setBtnDelegate(indexPath.row, self)
            
            let text = item.coin_name! + " " + item.coin_code!
            let underLine = NSMutableAttributedString.init(string: text)
            underLine.addAttribute(.underlineStyle, value: 1, range: NSRange.init(location: 0, length: text.count))
            cell.titleText.attributedText = underLine
            
            cell.coinText.text = item.coin_code
            cell.price3Text.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: item.balance!, scale: 8)) // 보유 수량
            cell.price8Text.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: item.avg_coin_price!, scale: 8)) // 매수 평균가
            
            //매수 금액
            let buyAmount = item.balance! * item.avg_coin_price!
            cell.price6Text.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: buyAmount, scale: 8)) //매수 금액
            
            //평가 금액
            let valuationAmount = item.balance! * item.now_price!
            //평가 손익
            let profit = valuationAmount - buyAmount
            //평가 수익률
            var per = Decimal(0)
            if(buyAmount != Decimal.zero){
                per = profit / buyAmount * Decimal(100.0)
            }
            
            cell.price4Text.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: valuationAmount, scale: 8)) //평가금액
            cell.price2Text.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: per, scale: 2)) //평가수익률
            
            
            cell.price5Text.text = "0"
            cell.price7Text.text = "0"
            if let marketKrw = appInfo.krwValue{
                cell.price5Text.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: valuationAmount * marketKrw, scale: 0)) //한화 평가금액
                cell.price7Text.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: buyAmount * marketKrw, scale: 0))// 한화 매수금액
                cell.price1Text.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: profit * marketKrw, scale: 0)) //평가 손익
                
            }
        }
        
        
        
        return cell
    }
}
