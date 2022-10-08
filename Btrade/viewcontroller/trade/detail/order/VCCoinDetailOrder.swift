//
//  VCCoinDetailOrder.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/01.
//


import Foundation
import Alamofire
import PagingKit
import FirebaseDatabase

class VCCoinDetailOrder: VCBase{
    let HOGAMAX = 10
    var vcDetail:VCCoinDetail?
    var vcCoinDetailOrderRight:VCCoinDetailOrderRight?
    
    @IBOutlet weak var hogaTableView: UITableView!
    
    var mArrayHogyBuy:Array<[String:Any?]?> = Array<[String:Any?]?>()
    var mArrayHogySell:Array<[String:Any?]?> = Array<[String:Any?]?>()
    
    var mAmountBuy:Double = 0
    var mAmountSell:Double = 0
    var mAmountMaxBuy:Double = 0
    var mAmountMaxSell:Double = 0
    
    var volumeAllSize:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHogaBuyData()
        initHogaSellData()
        initHogaLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vcDetail?.setInterface(self)
        setHogaLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VCCoinDetailOrderRight {
            vcCoinDetailOrderRight = vc
        }
    }
}


//MARK - hogaLayout
extension VCCoinDetailOrder{
    fileprivate func initHogaLayout(){
        let nibName = UINib(nibName: "OrderHogaCell", bundle: nil)
        self.hogaTableView.register(nibName, forCellReuseIdentifier: "OrderHogaCell")
        self.hogaTableView.rowHeight = UITableView.automaticDimension
        self.hogaTableView.estimatedRowHeight = 120
        self.hogaTableView.dataSource = self
        self.hogaTableView.delegate = self
        self.hogaTableView.separatorInset.left = 0
        
    }
    
    fileprivate func setHogaLayout(){
        initHogaBuyData()
        initHogaSellData()
        hogaTableView.reloadData()
    }
    
    fileprivate func initHogaBuyData(){
        mArrayHogyBuy.removeAll();
        mAmountBuy = 0
        mAmountMaxBuy = 0
        for idx in (1 ... HOGAMAX){
            guard let hoga = appInfo.getFirebaseHoga()?.getHOGA(VCCoinDetail.coin?.coin_code ?? "") else{
                mArrayHogyBuy.append(nil)
                continue
            }
            var buy = [String:Any?]()
            if let price = hoga["hoga_buy_" + String(idx)]{
                buy["price"] = price
            }else{
                buy["price"] = nil
            }
            if let amount = hoga["hoga_buy_amount_" + String(idx)]{
                buy["amount"] = amount
                let a = NSDecimalNumber(decimal: DoubleDecimalUtils.newInstance(amount as? String)).doubleValue
                mAmountBuy = mAmountBuy + a
                if(mAmountMaxBuy < a){mAmountMaxBuy = a}
            }else{
                buy["amount"] = nil
            }
            mArrayHogyBuy.append(buy)
        }
        
    }
    
    fileprivate func initHogaSellData(){
        mArrayHogySell.removeAll();
        mAmountSell = 0
        mAmountMaxSell = 0
        for idx in (1 ... HOGAMAX).reversed(){
            guard let hoga = appInfo.getFirebaseHoga()?.getHOGA(VCCoinDetail.coin?.coin_code ?? "")  else{
                mArrayHogySell.append(nil)
                continue
            }
            var sell = [String:Any?]()
            if let price = hoga["hoga_sell_" + String(idx)]{
                sell["price"] = price
            }else{
                sell["price"] = nil
            }
            if let amount = hoga["hoga_sell_amount_" + String(idx)]{
                sell["amount"] = amount
                let a = NSDecimalNumber(decimal: DoubleDecimalUtils.newInstance(amount as? String)).doubleValue
                mAmountSell = mAmountSell + a
                if(mAmountMaxSell < a){mAmountMaxSell = a}
            }else{
                sell["amount"] = nil
            }
            mArrayHogySell.append(sell)
        }
        
    }
    
    fileprivate func getHogaCellData(_ idx:Int) -> [String:Any?]?{
        if(idx < HOGAMAX){
            return mArrayHogySell[idx]
        }
        return mArrayHogyBuy[idx % HOGAMAX]
    }
    
    fileprivate func setHogaCell(_ cell:OrderHogaCell ,_ indexPath: IndexPath){
        let idx = indexPath.row
        let hoga = getHogaCellData(idx)
        
        let price = DoubleDecimalUtils.newInstance(hoga?["price"] as? String)
        let amount = DoubleDecimalUtils.newInstance(hoga?["amount"] as? String)
            
        let krwPrice = Int(DoubleDecimalUtils.mul(price , appInfo.krwValue!))
        cell.priceKrwText.text = CoinUtils.currency(krwPrice) + "KRW"
        cell.priceText.text = String(format: "%.8f", NSDecimalNumber(decimal: price).doubleValue)
        cell.volumeText.text = String(format: "%.8f", NSDecimalNumber(decimal: amount).doubleValue)
        
        var per = 0.0
        
        var color:UIColor?
        if(idx < HOGAMAX){//sell
            cell.priceLayout.backgroundColor = UIColor(named: "HogaSellBack")
            cell.volumeLayout.backgroundColor = UIColor(named: "HogaSellBack")
            cell.priceText.textColor = UIColor(named: "HogaPriceBlue")
            color = UIColor(named: "HogaSellBar")
            per = DoubleDecimalUtils.div(amount, DoubleDecimalUtils.newInstance(mAmountMaxSell)) / 100
            if(per < 0.01 || mAmountMaxSell == 0){per = 0.01}
        }else{
            cell.priceLayout.backgroundColor = UIColor(named: "HogaBuyBack")
            cell.volumeLayout.backgroundColor = UIColor(named: "HogaBuyBack")
            cell.priceText.textColor = UIColor(named: "HogaPriceRed")
            color = UIColor(named: "HogaBuyBar")
            per = DoubleDecimalUtils.div(amount, DoubleDecimalUtils.newInstance(mAmountMaxBuy)) / 100
            if(per < 0.01 || mAmountMaxBuy == 0){per = 0.01}
        }
        
        
        if(per > 1){per = 1}
        
        var size = (hogaTableView.frame.size.width / 2.0) * per
        if(size < 1){size = 1}
        if(size > (hogaTableView.frame.size.width / 2.0) ){size = (hogaTableView.frame.size.width / 2.0)}
        
        
        cell.volumeBarWidth.constant = size
        cell.volumeLayout.layoutIfNeeded()
        cell.volumeBar.backgroundColor = color
        
    }
}

extension VCCoinDetailOrder: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHogaCell", for: indexPath) as? OrderHogaCell else {
            return UITableViewCell()
        }
        if(volumeAllSize == nil){volumeAllSize = cell.volumeLayout.frame.size.width}
        self.setHogaCell(cell, indexPath)
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let hoga = getHogaCellData(indexPath.row){
            if let price = hoga["price"] as? String{
                vcCoinDetailOrderRight?.setPrice(price)
            }
        }
    }
}


extension VCCoinDetailOrder: FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        if let sender = vcCoinDetailOrderRight{
            sender.onDataChange(market: market)
        }
        setHogaLayout();
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        if let sender = vcCoinDetailOrderRight{
            sender.onDataChange(snapshot: snapshot)
        }
        setHogaLayout()
    }
}


class OrderHogaCell:UITableViewCell{
    @IBOutlet weak var priceLayout: UIView!
    @IBOutlet weak var volumeLayout: UIView!
    @IBOutlet weak var volumeText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var priceKrwText: UILabel!
    @IBOutlet weak var volumeBar: UILabel!
    @IBOutlet weak var volumeBarWidth: NSLayoutConstraint!
}
