//
//  VCCoinDetail.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/01.
//

import Foundation
import Alamofire
import PagingKit
import FirebaseDatabase

class VCCoinDetail: VCBase , FirebaseInterface, ValueEventListener{
    static var MARKETTYPE:String? = "BTC"
    static var coin:CoinVo?
    var firebaseInterface:VCBase?
    
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var backBtn1: UILabel!
    @IBOutlet weak var backBtn2: UILabel!
    
    
    @IBOutlet weak var favoritesBtn: UIImageView!
    @IBOutlet weak var coinNameText: UILabel!
    @IBOutlet weak var coinListBtn: UIImageView!
    @IBOutlet weak var coinCodeText: UILabel!
    @IBOutlet weak var coinPriceText: UILabel!
    @IBOutlet weak var coinKrwPrice: UILabel!
    @IBOutlet weak var changePriceText: UILabel!
    @IBOutlet weak var changePerText: UILabel!
    
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    var dataSource = Array<(menuTitle: String, vc: VCBase)>()
    var vcCoinDetailOrder = {() -> VCCoinDetailOrder in
        let sb = UIStoryboard.init(name:"Trade", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "coindetailordervc") as? VCCoinDetailOrder
        return vc!
    }()
    var vcCoinDetailHoga = {() -> VCCoinDetailHoga in
        let sb = UIStoryboard.init(name:"Trade", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCCoinDetailHoga") as? VCCoinDetailHoga
        return vc!
    }()
    var vcCoinDetailChart = {() -> VCCoinDetailChart in
        let sb = UIStoryboard.init(name:"Trade", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCCoinDetailChart") as? VCCoinDetailChart
        return vc!
    }()
    
    var vcCoinDetailQuote = {() -> VCCoinDetailQuote in
        let sb = UIStoryboard.init(name:"Trade", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCCoinDetailQuote") as? VCCoinDetailQuote
        return vc!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vcCoinDetailOrder.vcDetail = self
        vcCoinDetailHoga.vcDetail = self
        vcCoinDetailChart.vcDetail = self
        vcCoinDetailQuote.vcDetail = self
        
        dataSource = [(menuTitle: "주문", vc: vcCoinDetailOrder), (menuTitle: "호가", vc: vcCoinDetailHoga), (menuTitle: "차트", vc: vcCoinDetailChart), (menuTitle: "시세", vc: vcCoinDetailQuote)]
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        backBtn1.isUserInteractionEnabled = true
        backBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        backBtn2.isUserInteractionEnabled = true
        backBtn2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        favoritesBtn.isUserInteractionEnabled = true
        favoritesBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        coinNameText.isUserInteractionEnabled = true
        coinNameText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        coinCodeText.isUserInteractionEnabled = true
        coinCodeText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        coinListBtn.isUserInteractionEnabled = true
        coinListBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        
        
        menuViewController.register(nib: UINib(nibName: "DetailMenuCell", bundle: nil), forCellWithReuseIdentifier: "DetailMenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FAQFocusView", bundle: nil))
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        
        
        setTitleData()
        setImage()
    }
    
    @objc func onBtnClicked(sender:UITapGestureRecognizer){
        if(sender.view == backBtn || sender.view == backBtn1 || sender.view == backBtn2){
            stop()
        }else if(sender.view == favoritesBtn){
            clickedSavorites()
        }else if(sender.view == coinNameText || sender.view == coinListBtn || sender.view == coinCodeText){
            showCoinList();
        }
    }
    
    fileprivate func setTitleData(){
        if var _ = VCCoinDetail.coin{
            coinNameText.text = VCCoinDetail.coin?.kr_coin_name
            coinCodeText.text = VCCoinDetail.coin?.coin_code ?? ""
            coinCodeText.text = coinCodeText.text! + "/" + (VCCoinDetail.MARKETTYPE ?? "")
            guard let hoga = VCCoinDetail.coin?.firebaseHoga else{return}
            guard let hogaSub = hoga.getHOGASUB() else{return}
            guard let _ = appInfo.krwValue else{return}
            
            let now_price = DoubleDecimalUtils.newInstance(hogaSub["PRICE_NOW"] as? Double)
            let prev_price = DoubleDecimalUtils.newInstance(hogaSub["CLOSING_PRICE"] as? Double)
            let dif_price = DoubleDecimalUtils.subtract(now_price, prev_price);
            let dif_per = DoubleDecimalUtils.div(DoubleDecimalUtils.newInstance(dif_price), prev_price)
            let str_dif = String(format: "%.2f", dif_per)
            let krwPrice = Int(DoubleDecimalUtils.mul(now_price, appInfo.krwValue!))
            
            coinPriceText.text = String(format: "%.8f", NSDecimalNumber(decimal: now_price).doubleValue)
            coinKrwPrice.text = CoinUtils.currency(krwPrice) + "KRW"
            changePriceText.text = String(format: "%.8f", dif_price)
            changePerText.text = str_dif + "%"
            
            var color = UIColor.gray
            if(dif_price > 0){
                color = .red
                changePriceText.text = "+" + (changePriceText.text ?? "")
                changePerText.text = "▴" + (changePerText.text ?? "")
            }else if(dif_price < 0){
                color = .blue
                changePerText.text = "▾" + (changePerText.text ?? "").replacingOccurrences(of: "-", with: "")
            }
            
            coinPriceText.textColor = color
            changePriceText.textColor = color
            changePerText.textColor = color
            
        }
    }
    
    fileprivate func stop(){
        UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appInfo.setBtcInterface(nil)
        appInfo.setKrwInterface(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appInfo.setBtcInterface(self)
        appInfo.setKrwInterface(self)
        setTitleData()
        setImage()
    }
    
    
    func setInterface(_ firebaseInterface:VCBase?) {
        self.firebaseInterface = firebaseInterface
    }

    
    func onDataChange(market: String) {
        if let sender = firebaseInterface as? FirebaseInterface{
            sender.onDataChange(market: market)
        }
        setTitleData()
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        if let sender = firebaseInterface as? ValueEventListener{
            sender.onDataChange(snapshot: snapshot)
        }
        setTitleData()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? StarCheckRequest{
            let data = StarCheckResponse(baseResponce: response)
            let attention = data.getAttentionCoin()
            DispatchQueue.main.async{
                if(!attention){
                    var temp = [String:Any?]()
                    temp["attention_coin_BTC"] = "Y"
                    guard let _ = VCCoinDetail.coin?.myCoinData else{
                        VCCoinDetail.coin?.setCoinData(temp as NSDictionary)
                        self.setImage()
                        return
                    }
                    VCCoinDetail.coin?.myCoinData?["attention_coin_BTC"] = "Y"
                    self.setImage()
                }else{
                    VCCoinDetail.coin?.myCoinData?["attention_coin_BTC"] = nil
                    self.setImage()
                }
            }
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
}


//MARK - pagingkit
extension VCCoinDetail{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self
            stopScroll()
        }
    }
    
    fileprivate func stopScroll(){
        for view in self.contentViewController.view.subviews{
            if let subView = view as? UIScrollView{
                subView.isScrollEnabled = false
            }
        }
    }
}

extension VCCoinDetail: PagingMenuViewControllerDataSource, PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        let device = DeviceUtils().getSizeByHeight()
        var addHeight:CGFloat = 0
        if device == .iPhone8 || device == .iPhoneMini{
            addHeight = 40
        }
        
        var width = CGFloat(viewController.view.frame.size.width) - addHeight
        width = width / CGFloat(dataSource.count)
        return width
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "DetailMenuCell", for: index) as! DetailMenuCell
        cell.titleText.text = dataSource[index].menuTitle
        //WHERE = index
        return cell
    }
}

extension VCCoinDetail: PagingContentViewControllerDataSource, PagingContentViewControllerDelegate {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].vc
    }
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}

class DetailMenuCell: PagingMenuViewCell {
    @IBOutlet weak var titleText: UILabel!
}



//MARK: - TradeCoinList
extension VCCoinDetail{
    fileprivate func showCoinList(){
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "TradeCoinList") as? TradeCoinList else {
            return
        }
        vc.coin_code = VCCoinDetail.coin?.coin_code ?? ""
        vc.detailDelegate = {[self] coinVo in
            VCCoinDetail.coin = coinVo
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tradedetailvc") as? VCCoinDetail else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true);
    }
}


//MARK: - Favorites
extension VCCoinDetail{
    fileprivate func setImage(){
        favoritesBtn.image = UIImage(named: "star_deactive")
        if let _ = VCCoinDetail.coin?.myCoinData{
            if let attention = VCCoinDetail.coin?.myCoinData?["attention_coin_BTC"] as? String{
                if attention == "Y" {
                    favoritesBtn.image = UIImage(named: "start_active")
                }
            }
        }
    }
    
    fileprivate func clickedSavorites(){
        let request = StarCheckRequest()
        request.coinType = VCCoinDetail.coin?.coin_code
        request.market_type = VCCoinDetail.MARKETTYPE
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
   
}

