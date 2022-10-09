//
//  VCCoinDetailQuote.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/08.
//

import UIKit
import FirebaseDatabase

class VCCoinDetailQuote:VCBase{
    var vcDetail:VCCoinDetail?
    
    let HEIGHTSIZE:CGFloat = 25.0
    let HOUR = "hour"
    let DAY = "day"
    var MAINCATEGORY:String = ""
    
    var tempDic:[Int64:Quote] = [Int64:Quote]()
    var prePrice:Double = 0
    var mArray:Array<Quote> = Array<Quote>()
    
    @IBOutlet weak var mList: UITableView!
    
    @IBOutlet weak var dayBnt: UILabel!
    @IBOutlet weak var hourTitleLayout: UIView!
    @IBOutlet weak var houreTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var hourTitleMarketText: UILabel!
    @IBOutlet weak var hourTitleCoinText: UILabel!
    
    
    @IBOutlet weak var hourBnt: UILabel!
    @IBOutlet weak var dayTitleLayout: UIView!
    @IBOutlet weak var daylayoutHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        
        
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        mList.separatorStyle = .none
        mList.rowHeight = HEIGHTSIZE
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initLayout()
    }
    
    fileprivate func initLayout(){
        MAINCATEGORY = HOUR

        hourBnt.isUserInteractionEnabled = true
        hourBnt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        dayBnt.isUserInteractionEnabled = true
        dayBnt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        
        hourBnt.layer.cornerRadius = 5
        hourBnt.layer.borderWidth = 1
        hourBnt.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        dayBnt.layer.cornerRadius = 5
        dayBnt.layer.borderWidth = 1
        dayBnt.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner)
        
        hourTitleLayout.layer.borderWidth = 1
        hourTitleLayout.layer.borderColor = UIColor(named: "Ccacaca")?.cgColor
        dayTitleLayout.layer.borderWidth = 1
        dayTitleLayout.layer.borderColor = UIColor(named: "Ccacaca")?.cgColor
        
        drawLayoutTap()
    }
    
    fileprivate func startGetEvent(_ query:String){
        FirebaseDatabaseHelper.getInstance().onChart(self, query, VCCoinDetail.MARKETTYPE ?? "BTC", VCCoinDetail.coin?.coin_code ?? "ETH")
    }
    
    
    fileprivate func drawLayoutTap(){
        hourBnt.clipsToBounds = true
        dayBnt.clipsToBounds = true
        
        mArray.removeAll()
        mList.reloadData()
        if(MAINCATEGORY == HOUR){
            hourBnt.layer.borderColor = UIColor(named: "CoinSortActive")?.cgColor
            hourBnt.textColor = UIColor(named: "CoinSortActive")
            dayBnt.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
            dayBnt.textColor = UIColor(named: "C9499A8")
            
            houreTitleHeight.constant = HEIGHTSIZE
            daylayoutHeight.constant = 0
            if let coin = VCCoinDetail.coin?.coin_code{
                hourTitleCoinText.text = "체결량(" + coin + ")"
            }
            if let market = VCCoinDetail.MARKETTYPE{
                hourTitleMarketText.text = "체결가격(" + market + ")"
            }
            startGetEvent("1H")
        }else{
            hourBnt.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
            hourBnt.textColor = UIColor(named: "C9499A8")
            dayBnt.layer.borderColor = UIColor(named: "CoinSortActive")?.cgColor
            dayBnt.textColor = UIColor(named: "CoinSortActive")
            
            houreTitleHeight.constant = 0
            daylayoutHeight.constant = HEIGHTSIZE
            startGetEvent("1D")
        }
        
    }
    

    
    @objc func selectedTab(sender:UITapGestureRecognizer){
        if(sender.view == hourBnt){
            if(MAINCATEGORY == HOUR){return}
            MAINCATEGORY = HOUR
            drawLayoutTap()
        }else if(sender.view == dayBnt){
            if(MAINCATEGORY == DAY){return}
            MAINCATEGORY = DAY
            drawLayoutTap()
        }
    }
    
}

extension VCCoinDetailQuote:ValueEventListener{
    func onDataChange(snapshot: DataSnapshot) {
        if let data = snapshot.value as? [String:AnyObject]{
            tempDic.removeAll()
            prePrice = 0
            getQuoteData(data)
            let sortData = tempDic.sorted{$0.0 > $1.0}
            arrayData(sortData)
            mList.reloadData()
        }
    }
    
    fileprivate func getQuoteData(_ d:[String:AnyObject],_ date:Int64 = 0){
        for (key, data) in d{
            if(data is Double || data is Int64){
                let high_price:Double = getDoubleData(d["high_price"])
                let low_price:Double = getDoubleData(d["low_price"])
                let start_price:Double = getDoubleData(d["start_price"])
                let trd_price:Double = getDoubleData(d["trd_price"])
                let trd_qty:Double = getDoubleData(d["trd_qty"])
                tempDic[date] = Quote(high_price: high_price, low_price: low_price, start_price: start_price, trd_price: trd_price, trd_qty: trd_qty, dateTime: date)
                return
            }else{
                getQuoteData(data as! [String:AnyObject], Int64(key) ?? 0)
            }
        }
    }
    
    fileprivate func arrayData(_ sortData:Array<(key: Int64, value: Quote)>){
        for data in sortData {
            mArray.append(data.value)
        }
    }
    
    fileprivate func getDoubleData(_ data:Optional<Any>) -> Double{
        if let a = data as? Double{
            return a
        }
        if let a = data as? Int64{
            return Double(a)
        }
        return 0
    }
}


extension VCCoinDetailQuote: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as? QuoteCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let item = mArray[indexPath.row]
        if(MAINCATEGORY == HOUR){
            cell.hourLayoutHeight.constant = HEIGHTSIZE
            cell.dayLayoutHeight.constant = 0
            
            cell.hour1Text.text = ""
            cell.hour2Text.text = ""
            cell.hour3Text.text = ""
            
            if let date = String(item.dateTime).toDate(){
                cell.hour1Text.text = date.toString()
            }
            
            cell.hour2Text.text = String(item.trd_price)
            cell.hour3Text.text = String(item.trd_qty)
            
            if(item.start_price > item.trd_price){
                cell.hour2Text.textColor = UIColor(named: "HogaPriceBlue")
                cell.hour3Text.textColor = UIColor(named: "HogaPriceBlue")
            }else if(item.start_price < item.trd_price){
                cell.hour2Text.textColor = UIColor(named: "HogaPriceRed")
                cell.hour3Text.textColor = UIColor(named: "HogaPriceRed")
            }else{
                cell.hour2Text.textColor = UIColor(named: "HogaPriceGray")
                cell.hour3Text.textColor = UIColor(named: "HogaPriceGray")
            }
        }else{
            cell.hourLayoutHeight.constant = 0
            cell.dayLayoutHeight.constant = HEIGHTSIZE
            
            
            cell.day1Text.text = ""
            cell.day2Text.text = ""
            cell.day3Text.text = "0.00%"
            cell.day4Text.text = ""
            
            if let date = String(item.dateTime).toDate1(){
                cell.day1Text.text = date.toString1()
            }
            
            cell.day2Text.text = DoubleDecimalUtils.removeLastZero(String(format: "%.8f", item.trd_price))
            cell.day4Text.text = String(item.trd_qty)
            print("trd_qty : " , item.trd_qty)
            
            cell.day2Text.textColor = UIColor(named: "HogaPriceGray")
            cell.day3Text.textColor = UIColor(named: "HogaPriceGray")
            
            if(mArray.count > indexPath.row + 1){
                let preItem = mArray[indexPath.row + 1]
                let diff = ((item.trd_price - preItem.trd_price) / preItem.trd_price) * 100
                cell.day3Text.text = String(format: "%.2f", diff)
                if let strDiff = Double(cell.day3Text.text!){
                    if(strDiff > 0){
                        cell.day2Text.textColor = UIColor(named: "HogaPriceRed")
                        cell.day3Text.textColor = UIColor(named: "HogaPriceRed")
                    }else if(strDiff < 0){
                        cell.day2Text.textColor = UIColor(named: "HogaPriceBlue")
                        cell.day3Text.textColor = UIColor(named: "HogaPriceBlue")
                    }
                }
                if(cell.day3Text.text! == "-0.00"){
                    cell.day3Text.text = cell.day3Text.text!.replacingOccurrences(of: "-", with: "")
                }
                cell.day3Text.text = cell.day3Text.text! + "%"
            }
        }
        
        return cell
    }
}



class QuoteCell: UITableViewCell{
    @IBOutlet weak var hour1Text: UILabel!
    @IBOutlet weak var hour2Text: UILabel!
    @IBOutlet weak var hour3Text: UILabel!
    @IBOutlet weak var day1Text: UILabel!
    @IBOutlet weak var day2Text: UILabel!
    @IBOutlet weak var day3Text: UILabel!
    @IBOutlet weak var day4Text: UILabel!
    
    @IBOutlet weak var hourLayoutHeight: NSLayoutConstraint!
    @IBOutlet weak var dayLayoutHeight: NSLayoutConstraint!
}

struct Quote{
    var high_price:Double
    var low_price:Double
    var start_price:Double
    var trd_price:Double
    var trd_qty:Double
    var dateTime:Int64
}

extension String {
    fileprivate func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    fileprivate func toDate1() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

extension Date {
    fileprivate func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    fileprivate func toString1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
