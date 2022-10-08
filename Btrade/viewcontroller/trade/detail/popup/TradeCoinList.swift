//
//  TradeCoinList.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/07.
//

import UIKit
import Alamofire
import PagingKit
import FirebaseDatabase


class TradeCoinList:VCBase, TradeCoin{
    var coin_code:String?
    var detailDelegate:((CoinVo) -> Void)?
    
    @IBOutlet weak var popupLayout: UIView!
    @IBOutlet weak var searchLayout: UIView!
    @IBOutlet weak var backBtn1: UIButton!
    @IBOutlet weak var backBtn2: UIImageView!
    @IBOutlet weak var searchText: UITextField!
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    
    var firebaseInterface:VCBase?
    var dataSource = Array<(menuTitle: String, vc: VCBase)>()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vcBtc.vcTrade = self;
        vcFavorites.vcTrade = self;
        vcPossession.vcTrade = self;
        
        dataSource = [(menuTitle: "BTC", vc: vcBtc), (menuTitle: "즐겨찾기", vc: vcFavorites), (menuTitle: "보유코인", vc: vcPossession)]
        menuViewController.register(nib: UINib(nibName: "TradeMenuCell", bundle: nil), forCellWithReuseIdentifier: "TradeMenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FAQFocusView", bundle: nil))
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        
        searchLayout.layer.borderWidth = 1
        searchLayout.layer.borderColor = UIColor.gray.cgColor
        searchLayout.layer.cornerRadius = 10
        
        
        popupLayout.clipsToBounds = true
        popupLayout.layer.cornerRadius = 30
        popupLayout.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        
        searchText.borderStyle = .none
        searchText.delegate = self
        searchText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        backBtn1.isUserInteractionEnabled = true
        backBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        backBtn2.isUserInteractionEnabled = true
        backBtn2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBtnClicked)))
        
    }
    
    func selectedCoin(_ coin:CoinVo){
        if(coin_code == coin.coin_code){
            stop()
            return
        }
        if let delegate = detailDelegate{
            stop()
            delegate(coin)
        }
        
    }
    
    @objc func onBtnClicked(sender:UITapGestureRecognizer){
        if(sender.view == backBtn1 || sender.view == backBtn2){
            stop()
        }
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ serder:Any?){
        if(firebaseInterface != nil && firebaseInterface is VCTradeBTC){vcBtc.searchStart(self.searchText.text)}
        if(firebaseInterface != nil && firebaseInterface is VCTradeFavorites){vcFavorites.searchStart(self.searchText.text)}
        if(firebaseInterface != nil && firebaseInterface is VCTradePossession){vcPossession.searchStart(self.searchText.text)}
    }
    
    func setInterface(_ firebaseInterface: VCBase?) {
        self.firebaseInterface = firebaseInterface
    }
    
    func searchInvisible() {
        self.searchText.text = ""
    }
}


extension TradeCoinList: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.searchText){
            if((textField.text! + string).count > 8 && string.count > 0){ return false }
        }
        return true
    }
}


//MARK - PagingKit
extension TradeCoinList{
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

extension TradeCoinList: PagingMenuViewControllerDataSource, PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
        self.searchInvisible()
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        var width = CGFloat(searchLayout.frame.size.width)
        width = width / CGFloat(dataSource.count)
        return width
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "TradeMenuCell", for: index) as! TradeMenuCell
        cell.titleText.text = dataSource[index].menuTitle
        return cell
    }
}

extension TradeCoinList:  PagingContentViewControllerDataSource, PagingContentViewControllerDelegate{
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
