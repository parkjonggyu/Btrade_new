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
    var totalBalance:Decimal = Decimal(0)
    var totalBuy:Decimal = Decimal(0)
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
            mList.tableHeaderView = assetHeaderView
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(vcAsset != nil){vcAsset?.setInterface(self)}
        
        if let b = vcAsset?.statusUpdate{
            if(b){
                vcAsset?.statusUpdate = false
                getData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(vcAsset != nil){vcAsset?.setInterface(nil)}
    }
    
    
    fileprivate func getData(){
        totalBalance = Decimal(0)
        totalBuy = Decimal(0)
        ApiFactory(apiResult: self, request: HoldingsRequest()).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? HoldingsRequest{
            let response = HoldingsResponse(baseResponce: response)
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
                            let total_buy = DoubleDecimalUtils.newInstance(toDouble(item["total_buy"]))
                            if(balance > 0){
                                if(coin_code == "BTC"){
                                    total += balance
                                    totalBtc += trade_can
                                }else{
                                    total +=  (balance * now_price)
                                    
                                    totalBalance +=  (balance * now_price)
                                    totalBuy = totalBuy + (total_buy * now_price)
                                    mArray.append(ASSET(coin_name: coin_name, coin_code: coin_code, balance: balance, now_price: now_price, trade_can: trade_can, total_buy: total_buy))
                                }
                                
                            }
                        }
                        
                        let result = CoinUtils.fCalcProfitDif(totalBalance, totalBuy, feeString: nil)
                        let totalProfitPercentage = DoubleDecimalUtils.newInstance(toDouble(result["dif_per_num"]))
                        let dif_num = DoubleDecimalUtils.newInstance(toDouble(result["dif_num"]))
                        
                        assetHeader = AssetHeader(total:total, totalBtc:totalBtc, totalProfitPercentage:totalProfitPercentage, dif_num:dif_num)
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
                v.totalProfitKrwText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: d.dif_num! * appInfo.krwValue!, scale: 0))
            }
        }
        mList.reloadData()
    }
}

struct ASSET{
    var coin_name:String?
    var coin_code:String?
    var balance:Decimal?
    var now_price:Decimal?
    var trade_can:Decimal?
    var total_buy:Decimal?
}


//MARK - Header View
struct AssetHeader{
    var total:Decimal?
    var totalBtc:Decimal?
    var totalProfitPercentage:Decimal?
    var dif_num:Decimal?
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
            v.totalProfitPerText.text = DoubleDecimalUtils.setMaximumFractionDigits(decimal: d.totalProfitPercentage!, scale: 2)
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
        
        if let item = mArray[indexPath.row] as? ASSET{
            cell.setBtnDelegate(indexPath.row, self)
            
            let text = item.coin_name! + " " + item.coin_code!
            let underLine = NSMutableAttributedString.init(string: text)
            underLine.addAttribute(.underlineStyle, value: 1, range: NSRange.init(location: 0, length: text.count))
            cell.titleText.attributedText = underLine
            
            cell.coinText.text = item.coin_code
            cell.price3Text.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: item.balance!, scale: 8))
            
            cell.price4Text.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: item.balance! * item.now_price!, scale: 8))
            cell.price6Text.text = DoubleDecimalUtils.removeLastZero(DoubleDecimalUtils.setMaximumFractionDigits(decimal: item.total_buy! * item.now_price!, scale: 8))
            
            let result = CoinUtils.fCalcProfitDif(item.balance! * item.now_price!, item.total_buy! * item.now_price!, feeString: nil)
            let profit = DoubleDecimalUtils.newInstance(result["dif_num"] as? Double)
            let profitPer = DoubleDecimalUtils.newInstance(result["dif_per_num"] as? Double)
            cell.price2Text.text = DoubleDecimalUtils.setMaximumFractionDigits(decimal: profitPer, scale: 2)
            
            cell.price5Text.text = "0"
            cell.price7Text.text = "0"
            if let marketKrw = appInfo.krwValue{
                cell.price5Text.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: item.balance! * item.now_price! * marketKrw, scale: 0))
                cell.price7Text.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: item.total_buy! * item.now_price! * marketKrw, scale: 0))
                cell.price1Text.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: profit * marketKrw, scale: 0))
                
            }
        }
        
        
        
        return cell
    }
}
