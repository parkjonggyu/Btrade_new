//
//  VCTrade.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/11.
//

import UIKit
import Alamofire
import PagingKit
import FirebaseDatabase

class VCTrade: VCBase , FirebaseInterface, ValueEventListener, TradeCoin{
    var vcBtc = {() -> VCTradeBTC in
        let sb = UIStoryboard.init(name:"Trade", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "tradebtcvc") as? VCTradeBTC
        return vc!
    }()
    var vcFavorites = {() -> VCTradeFavorites in
        let sb = UIStoryboard.init(name:"Trade", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "tradefavoritesvc") as? VCTradeFavorites
        return vc!
    }()
    var vcPossession = {() -> VCTradePossession in
        let sb = UIStoryboard.init(name:"Trade", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "tradepossessionvc") as? VCTradePossession
        return vc!
    }()
    
    var allList:Array<TradeItem> = Array<TradeItem>()
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var dataSource = Array<(menuTitle: String, vc: VCBase)>()
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    var firebaseInterface:VCBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vcBtc.vcTrade = self;
        vcFavorites.vcTrade = self;
        vcPossession.vcTrade = self;
        
        dataSource = [(menuTitle: "BTC", vc: vcBtc), (menuTitle: "즐겨찾기", vc: vcFavorites), (menuTitle: "보유코인", vc: vcPossession)]
        
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        menuViewController.register(nib: UINib(nibName: "TradeMenuCell", bundle: nil), forCellWithReuseIdentifier: "TradeMenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FAQFocusView", bundle: nil))
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        
        searchField.background = UIImage(named: "text_field_inactive.png")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("VCTrade viewWillDisappear")
        appInfo.setBtcInterface(nil)
        appInfo.setKrwInterface(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VCTrade viewDidAppear")
        appInfo.setBtcInterface(self)
        appInfo.setKrwInterface(self)
        getData()
    }
    
    func setInterface(_ firebaseInterface:VCBase?) {
        self.firebaseInterface = firebaseInterface
    }

    
    func onDataChange(market: String) {
        if let sender = firebaseInterface as? FirebaseInterface{
            sender.onDataChange(market: market)
        }
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        if let sender = firebaseInterface as? ValueEventListener{
            sender.onDataChange(snapshot: snapshot)
        }
    }

    fileprivate func getData(){
        if(appInfo.getIsLogin()){
            ApiFactory(apiResult: Main(self), request: MainRequest()).newThread()
        }
    }
        
    class Main:ApiResult{
        var vcTrade:VCTrade
        init(_ vcTrade:VCTrade){self.vcTrade = vcTrade}
        func onResult(response: BaseResponse) {
            if let _ = response.request as? MainRequest{
                let data = MainResponse(baseResponce: response)
                if let result = data.getJsonList() {
                    var a:NSArray?
                    do{
                        a = try JSONSerialization.jsonObject(with: Data(result.utf8), options: []) as? NSArray
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                    if let aa = a{
                        for item in aa{
                            if let dic = item as? NSDictionary{
                                if let code = dic["coin_code"] as? String{
                                    if let _ = vcTrade.appInfo.getCoinList(){
                                        for coin in vcTrade.appInfo.getCoinList()!{
                                            if(code.lowercased() == coin.coin_code.lowercased()){
                                                coin.setCoinData(dic)
                                                break
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    return
                }
                
            }
        }
        
        func onError(e: AFError, method: String) {}
    }
    
    @objc func textFieldDidChange(_ serder:Any?){
        if(firebaseInterface != nil && firebaseInterface is VCTradeBTC){vcBtc.searchStart(self.searchField?.text)}
        if(firebaseInterface != nil && firebaseInterface is VCTradeFavorites){vcFavorites.searchStart(self.searchField?.text)}
        if(firebaseInterface != nil && firebaseInterface is VCTradePossession){vcPossession.searchStart(self.searchField?.text)}
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? MypageFAQAllRequest{
            let data = MypageFAQAllResponse(baseResponce: response)
            let list = data.getList()
            if(list != nil){
                for item in list!{
                    let item = TradeItem(bg_idx: item["bg_idx"] as! Int, bg_cate_idx: item["bg_cate_idx"] as! Int, bg_title: item["bg_title"] as! String, bg_contents: item["bg_contents"] as! String, temp: false)
                    allList.append(item)
                }
            }
            
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    
    let SEARCHSIZE = 150.0
    @IBAction func clickedSearch(_ sender: Any) {
        if(searchField.frame.size.width <= (SEARCHSIZE / 2)){
            searchVisible()
        }else{
            searchInvisible()
            if(firebaseInterface != nil && firebaseInterface is VCTradeBTC){vcBtc.searchStart("")}
            if(firebaseInterface != nil && firebaseInterface is VCTradeFavorites){vcFavorites.searchStart("")}
            if(firebaseInterface != nil && firebaseInterface is VCTradePossession){vcPossession.searchStart("")}
        
        }
    }
    
    func searchVisible(){
        self.searchField.translatesAutoresizingMaskIntoConstraints = true
        self.searchBtn.translatesAutoresizingMaskIntoConstraints = true
        if(searchField.frame.size.width <= (SEARCHSIZE / 2)){
            if(firebaseInterface != nil && firebaseInterface is VCTradeBTC){vcBtc.initSort()}
            if(firebaseInterface != nil && firebaseInterface is VCTradeFavorites){vcFavorites.initSort()}
            if(firebaseInterface != nil && firebaseInterface is VCTradePossession){vcPossession.initSort()}
            
            
            searchBtn.frame.origin.x = searchBtn.frame.origin.x - SEARCHSIZE
            searchField.frame.origin.x = searchField.frame.origin.x - SEARCHSIZE
            searchField.frame.size.width = searchField.frame.size.width + SEARCHSIZE
            searchField.becomeFirstResponder()
        }
    }
    
    func searchInvisible(){
        self.searchField.translatesAutoresizingMaskIntoConstraints = true
        self.searchBtn.translatesAutoresizingMaskIntoConstraints = true
        if(searchField.frame.size.width > (SEARCHSIZE / 2)){
            searchBtn.frame.origin.x = searchBtn.frame.origin.x + SEARCHSIZE
            searchField.frame.origin.x = searchField.frame.origin.x + SEARCHSIZE
            searchField.frame.size.width = searchField.frame.size.width - SEARCHSIZE
            searchField.text = ""
            self.view.endEditing(true)
        }
    }
    
}


//MARK - PagingKit
extension VCTrade{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.cellAlignment = .center
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

extension VCTrade: PagingMenuViewControllerDataSource, PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
        self.searchInvisible()
        
        for idx in 0 ..< dataSource.count{  // 선택된 셀 폰트 변경
            if let c = viewController.cellForItem(at:idx) as? TradeMenuCell{
                if(idx == page){
                    c.titleText.textColor = UIColor(named: "C515151")
                    c.titleText.font = UIFont.boldSystemFont(ofSize: 16)
                }else{
                    c.titleText.textColor = UIColor(named: "CA1A1A1")
                    c.titleText.font = UIFont.systemFont(ofSize: 16)
                }
            }
        }
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
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "TradeMenuCell", for: index) as! TradeMenuCell
        cell.titleText.text = dataSource[index].menuTitle
        if(0 == index){
            cell.titleText.textColor = UIColor(named: "C515151")
            cell.titleText.font = UIFont.boldSystemFont(ofSize: 16)
        }else{
            cell.titleText.textColor = UIColor(named: "CA1A1A1")
            cell.titleText.font = UIFont.systemFont(ofSize: 16)
        }
        
        
        
        return cell
    }
}

extension VCTrade:  PagingContentViewControllerDataSource, PagingContentViewControllerDelegate{
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

extension VCTrade: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == searchField){
            if((textField.text! + string).count > 8 && string.count > 0){ return false }
        }
        return true
    }
    
}


class TradeMenuCell: PagingMenuViewCell {
    @IBOutlet weak var titleText: UILabel!
}

struct TradeItem{
    var bg_idx:Int
    var bg_cate_idx:Int
    var bg_title:String
    var bg_contents:String
    var temp:Bool
    var webViewSize:Int? = 0
    mutating func changeSize(_ size:Int){
        webViewSize = size
    }
}

class TradeCoinCell: UITableViewCell{
    @IBOutlet weak var mTextName: UILabel!
    @IBOutlet weak var mTextNameCode: UILabel!
    @IBOutlet weak var mTextPrice: UILabel!
    @IBOutlet weak var mTextPriceKrw: UILabel!
    @IBOutlet weak var mTextPer: UILabel!
    @IBOutlet weak var mTextVol: UILabel!
    @IBOutlet weak var mTextVolKrw: UILabel!
    @IBOutlet weak var mCandleImage: UIImageView!
}

protocol TradeCoin{
    func setInterface(_ firebaseInterface:VCBase?)
    func searchInvisible()
}
