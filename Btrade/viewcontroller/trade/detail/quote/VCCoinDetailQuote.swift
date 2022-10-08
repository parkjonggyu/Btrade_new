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
    
    
    var mArray:Array<MyTradeItem> = Array<MyTradeItem>()
    
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
        FirebaseDatabaseHelper.getInstance().onChart(self, query, VCCoinDetail.MARKETTYPE, VCCoinDetail.coin?.coin_code ?? "ETH")
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
            
            self?.appInfo?.setFirebaseHoga(f: FirebaseHoga(data as NSDictionary))
            if let _ = self?.listener{
                self?.listener?.onDataChange(market: "ALL")
            }
        }
    }
}


extension VCCoinDetailQuote: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTradeCoinCell", for: indexPath) as? MyTradeCoinCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        if(MAINCATEGORY == HOUR){
            cell.hourLayoutHeight.constant = HEIGHTSIZE
            cell.dayLayoutHeight.constant = 0
        }else{
            cell.hourLayoutHeight.constant = 0
            cell.dayLayoutHeight.constant = HEIGHTSIZE
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



class MyTradeCoinCell: UITableViewCell{
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
    var high_price:Double?
    var low_price:Double?
    var start_price:Double?
    var trd_price:Double?
    var trd_qty:Double?
}
