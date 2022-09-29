//
//  VCTradeBTC.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/27.
//
import UIKit

class VCTradeBTC: VCBase ,UITableViewDataSource, UITableViewDelegate {
    var calc = TradeCalc()
    @IBOutlet weak var mList: UITableView!
    
    var mArray:Array<CoinVo> = Array()
    var tradeCalc:TradeCalc = TradeCalc()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mList.register(UINib(nibName: "TradeCoinCell", bundle: nil), forCellReuseIdentifier: "tradecoincell")
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        
    }
    
    fileprivate func initSort(){
        
    }
    
    func setArrayList(_ array:Array<CoinVo>?){
        if let newarray = array{
            mArray.removeAll()
            for coin in newarray{
                mArray.append(coin)
            }
            self.mList.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tradecoincell", for: indexPath) as? TradeCoinCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let item = mArray[indexPath.row]
        cell.mTextName.text = item.kr_coin_name
        cell.mTextNameCode.text = item.coin_code + "/BTC"
        
        guard let hoga = item.firebaseHoga else{
            return cell
        }
        
        guard let hogaSub = hoga.getHOGASUB() else{
            return cell
        }
        
        
        let now_price = DoubleDecimalUtils.newInstance(hogaSub["PRICE_NOW"] as? Double)
        let prev_price = DoubleDecimalUtils.newInstance(hogaSub["CLOSING_PRICE"] as? Double)
//        let sell_vol = DoubleDecimalUtils.newInstance(hogaSub["AMOUNT_TOTAL_SELL"] as? String)
//        let buy_vol = DoubleDecimalUtils.newInstance(hogaSub["AMOUNT_TOTAL_BUY"] as? String)
        let vol = DoubleDecimalUtils.newInstance(hogaSub["TODAY_TOTAL_COST"] as? Double)
        
        var dif_price = DoubleDecimalUtils.subtract(now_price, prev_price);
        var dif_per = DoubleDecimalUtils.div(DoubleDecimalUtils.newInstance(dif_price), prev_price)
        
        let str_dif = String(format: "%.2f", dif_per)
        var double_dif = Double(str_dif) ?? 0
        
        tradeCalc.makeCandleImage(hogaSub: hogaSub, double_dif, item.kr_coin_name, cell.mCandleImage)
        
        if(double_dif > 0){
            cell.mTextPrice.textColor = .red
            cell.mTextPer.textColor = .red
        }else if (double_dif == 0){
            cell.mTextPrice.textColor = .gray
            cell.mTextPer.textColor = .gray
        }else {
            cell.mTextPrice.textColor = .blue
            cell.mTextPer.textColor = .blue
        }
        
        print("vol" ,String(format: "%.3f", NSDecimalNumber(decimal: vol).doubleValue))
        print("now_price : " , String(format: "%.3f", NSDecimalNumber(decimal: now_price).doubleValue))
        cell.mTextVol.text = String(format: "%.3f", NSDecimalNumber(decimal: vol).doubleValue)
        cell.mTextPrice.text = String(format: "%.8f", NSDecimalNumber(decimal: now_price).doubleValue)
        cell.mTextPer.text = str_dif + "%"
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "boardnoticedetailvc") as? VCBoardNoticeDetail else {
            return
        }
              
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
}



