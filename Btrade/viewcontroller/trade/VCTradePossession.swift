//
//  VCTradePossession.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/27.
//
import UIKit
import FirebaseDatabase

class VCTradePossession: VCBase  ,UITableViewDataSource, UITableViewDelegate , FirebaseInterface, ValueEventListener{
    enum COINSORT{
        case NORMAL
        case UP
        case DOWN
    }
    
    
    @IBOutlet weak var sort1Text: UILabel!
    @IBOutlet weak var sort1Image: UIImageView!
    var sort1 = COINSORT.NORMAL
    
    @IBOutlet weak var sort2Text: UILabel!
    @IBOutlet weak var sort2Image: UIImageView!
    var sort2 = COINSORT.NORMAL
    
    @IBOutlet weak var sort3Text: UILabel!
    @IBOutlet weak var sort3Image: UIImageView!
    var sort3 = COINSORT.NORMAL
    
    @IBOutlet weak var sort4Text: UILabel!
    @IBOutlet weak var sort4Image: UIImageView!
    var sort4 = COINSORT.NORMAL
    
    @IBOutlet weak var mList: UITableView!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var cntZeroText: UILabel!
    
    var mArray:Array<CoinVo> = Array()
    var vcTrade:VCTrade?
    
    var tradeCalc:TradeCalc!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tradeCalc = TradeCalc(appInfo)
        
        sort1Text.isUserInteractionEnabled = true
        sort1Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSort)))
        sort1Image.isUserInteractionEnabled = true
        sort1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSort)))
        
        sort2Text.isUserInteractionEnabled = true
        sort2Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSort)))
        sort2Image.isUserInteractionEnabled = true
        sort2Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSort)))
        
        sort3Text.isUserInteractionEnabled = true
        sort3Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSort)))
        sort3Image.isUserInteractionEnabled = true
        sort3Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSort)))
        
        sort4Text.isUserInteractionEnabled = true
        sort4Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSort)))
        sort4Image.isUserInteractionEnabled = true
        sort4Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSort)))
        
        
        
        mList.register(UINib(nibName: "TradeCoinCell", bundle: nil), forCellReuseIdentifier: "tradecoincell")
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        
        cntZeroText.layer.isHidden = true
        contentView.layer.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(vcTrade != nil){vcTrade?.setInterface(self)}
        setArrayList(getCoinList())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(vcTrade != nil){vcTrade?.setInterface(nil)}
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tradecoincell", for: indexPath) as? TradeCoinCell else {
            return UITableViewCell()
        }
        
        return tradeCalc.setCellData(cell: cell, item: mArray[indexPath.row])
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tradedetailvc") as? VCCoinDetail else {
            return
        }
        VCCoinDetail.coin = mArray[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
    func onDataChange(market: String) {
        mList.reloadData()
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        mList.reloadData()
    }
}


// MARK - Sort
extension VCTradePossession{
    func getCoinList() -> Array<CoinVo>?{
        var coins = Array<CoinVo>()
        if let newarray = appInfo.getCoinList(){
            for coin in newarray{
                if let _ = coin.myCoinData{
                    if let balance = coin.myCoinData?["balance"] as? Int64{
                        if balance > 0 {
                            coins.append(coin)
                        }
                    }else if let balance = coin.myCoinData?["balance"] as? Double{
                        if balance > 0 {
                            coins.append(coin)
                        }
                    }
                }
            }
        }
        return coins
    }
    
    func setArrayList(_ array:Array<CoinVo>?){
        if let newarray = array{
            mArray.removeAll()
            for coin in newarray{
                mArray.append(coin)
            }
            if(mArray.count > 0){
                cntZeroText.layer.isHidden = true
                contentView.layer.isHidden = false
                self.mList.reloadData()
            }else{
                cntZeroText.layer.isHidden = false
                contentView.layer.isHidden = true
            }
        }
    }
    
    @objc
    func goSort(sender:UITapGestureRecognizer){
        vcTrade?.searchInvisible()
        initSort();
        if(sender.view == sort1Text || sender.view == sort1Image){
            sort1 = nextSort(sort1)
            changeImageAndTextColor(sort1, sort1Text, sort1Image)
        }else if(sender.view == sort2Text || sender.view == sort2Image){
            sort2 = nextSort(sort2)
            changeImageAndTextColor(sort2, sort2Text, sort2Image)
        }else if(sender.view == sort3Text || sender.view == sort3Image){
            sort3 = nextSort(sort3)
            changeImageAndTextColor(sort3, sort3Text, sort3Image)
        }else if(sender.view == sort4Text || sender.view == sort4Image){
            sort4 = nextSort(sort4)
            changeImageAndTextColor(sort4, sort4Text, sort4Image)
        }
        setArrayList(sort())
    }
    
    fileprivate func sort() -> Array<CoinVo>?{
        if let newarray = getCoinList(){
            if(sort1 == .UP){
                return newarray.sorted(by: {$0.kr_coin_name > $1.kr_coin_name})
            }else if(sort1 == .DOWN){
                return newarray.sorted(by: {$0.kr_coin_name < $1.kr_coin_name})
            }else if(sort2 == .UP){
                return newarray.sorted(by: {($0.firebaseHoga?.getHOGASUB()?["PRICE_NOW"] as? Double) ?? 0 < ($1.firebaseHoga?.getHOGASUB()?["PRICE_NOW"] as? Double) ?? 0})
            }else if(sort2 == .DOWN){
                return newarray.sorted(by: {($0.firebaseHoga?.getHOGASUB()?["PRICE_NOW"] as? Double) ?? 0 > ($1.firebaseHoga?.getHOGASUB()?["PRICE_NOW"] as? Double) ?? 0})
            }else if(sort3 == .UP){
                return newarray.sorted { coin1, coin2 in
                    let now_price1 = (coin1.firebaseHoga?.getHOGASUB()?["PRICE_NOW"] as? Double) ?? 0
                    let prev_price1 = (coin1.firebaseHoga?.getHOGASUB()?["CLOSING_PRICE"] as? Double) ?? 1
                    let now_price2 = (coin2.firebaseHoga?.getHOGASUB()?["PRICE_NOW"] as? Double) ?? 0
                    let prev_price2 = (coin2.firebaseHoga?.getHOGASUB()?["CLOSING_PRICE"] as? Double) ?? 1
                    return ((now_price1 - prev_price1) / prev_price1) < ((now_price2 - prev_price2) / prev_price2)
                }
            }else if(sort3 == .DOWN){
                return newarray.sorted { coin1, coin2 in
                    let now_price1 = (coin1.firebaseHoga?.getHOGASUB()?["PRICE_NOW"] as? Double) ?? 0
                    let prev_price1 = (coin1.firebaseHoga?.getHOGASUB()?["CLOSING_PRICE"] as? Double) ?? 1
                    let now_price2 = (coin2.firebaseHoga?.getHOGASUB()?["PRICE_NOW"] as? Double) ?? 0
                    let prev_price2 = (coin2.firebaseHoga?.getHOGASUB()?["CLOSING_PRICE"] as? Double) ?? 1
                    return ((now_price1 - prev_price1) / prev_price1) > ((now_price2 - prev_price2) / prev_price2)
                }
            }else if(sort4 == .UP){
                return newarray.sorted(by: {($0.firebaseHoga?.getHOGASUB()?["TODAY_TOTAL_COST"] as? Double) ?? 0 < ($1.firebaseHoga?.getHOGASUB()?["TODAY_TOTAL_COST"] as? Double) ?? 0})
            }else if(sort4 == .DOWN){
                return newarray.sorted(by: {($0.firebaseHoga?.getHOGASUB()?["TODAY_TOTAL_COST"] as? Double) ?? 0 > ($1.firebaseHoga?.getHOGASUB()?["TODAY_TOTAL_COST"] as? Double) ?? 0})
            }
        }
        return nil
    }
    
    fileprivate func changeImageAndTextColor(_ sort:COINSORT,_ mText:UILabel,_ mImage:UIImageView){
        if(sort == .DOWN){
            mText.textColor = UIColor.init(named: "CoinSortActive")
            mImage.image = UIImage(named: "trade_arrow_down.png")
        }else if(sort == .UP){
            mText.textColor = UIColor.init(named: "CoinSortActive")
            mImage.image = UIImage(named: "trade_arrow_up.png")
        }
    }
    
    fileprivate func nextSort(_ sort:COINSORT) -> COINSORT{
        if(sort != sort1){sort1 = .NORMAL}
        if(sort != sort2){sort2 = .NORMAL}
        if(sort != sort3){sort3 = .NORMAL}
        if(sort != sort4){sort4 = .NORMAL}
            
        if(sort == .NORMAL || sort == .DOWN){
            return COINSORT.UP
        }
        return COINSORT.DOWN
    }
    
    func initSort(){
        sort1Text.textColor = UIColor.init(named: "CoinSortDeactive")
        sort2Text.textColor = UIColor.init(named: "CoinSortDeactive")
        sort3Text.textColor = UIColor.init(named: "CoinSortDeactive")
        sort4Text.textColor = UIColor.init(named: "CoinSortDeactive")
        sort1Image.image = UIImage(named: "trade_arrow_normal.png")
        sort2Image.image = UIImage(named: "trade_arrow_normal.png")
        sort3Image.image = UIImage(named: "trade_arrow_normal.png")
        sort4Image.image = UIImage(named: "trade_arrow_normal.png")
    }
    
    func searchStart(_ query:String?){
        if let _ = query{
            if let newarray = getCoinList(){
                mArray.removeAll()
                for coin in newarray{
                    if(coin.kr_coin_name.contains(query!) || coin.coin_code.contains(query!) || query == ""){
                        mArray.append(coin)
                    }
                }
                self.mList.reloadData()
            }
        }
    }
}
