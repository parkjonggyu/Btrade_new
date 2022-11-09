//
//  VCExchangeDetail.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/18.
//

import Foundation
import UIKit
import Alamofire
import PagingKit
import FirebaseDatabase

class VCExchangeDetail:VCBase {
    var vcDeposit = {() -> VCTabDeposit in
        let sb = UIStoryboard.init(name:"Exchange", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCTabDeposit") as? VCTabDeposit
        return vc!
    }()
    var vcWithdraw = {() -> VCTabWithdraw in
        let sb = UIStoryboard.init(name:"Exchange", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCTabWithdraw") as? VCTabWithdraw
        return vc!
    }()
    var vcHistory = {() -> VCTabHistory in
        let sb = UIStoryboard.init(name:"Exchange", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCTabHistory") as? VCTabHistory
        return vc!
    }()
    var vcCSDeposit = {() -> VCTabCSDeposit in
        let sb = UIStoryboard.init(name:"Exchange", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCTabCSDeposit") as? VCTabCSDeposit
        return vc!
    }()
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var dataSource = Array<(menuTitle: String, vc: VCBase)>()
    
    @IBOutlet weak var coinNameText: UILabel!
    @IBOutlet weak var titleLayout: UIStackView!
    @IBOutlet weak var boxLayout: UIView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var backBtn2: UIView!
    
    @IBOutlet weak var coinCodeText1: UILabel!
    @IBOutlet weak var coinCodeText2: UILabel!
    @IBOutlet weak var coinCodeText3: UILabel!
    
    @IBOutlet weak var holdingBtc: UILabel!
    @IBOutlet weak var holdingAmountText: UILabel!
    @IBOutlet weak var holdingIngText: UILabel!
    @IBOutlet weak var holdingAvailable: UILabel!
    
    
    var firebaseInterface:VCBase?
    
    var vcExchange:VCExchange?
    var coinCode:String?
    var coinName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vcDeposit.vcExchangeDetail = self
        vcWithdraw.vcExchangeDetail = self
        vcHistory.vcExchangeDetail = self
        vcCSDeposit.vcExchangeDetail = self
        
        
        initLayout()
        dataSource = [(menuTitle: "입금", vc: vcDeposit), (menuTitle: "출금", vc: vcWithdraw), (menuTitle: "내역", vc: vcHistory), (menuTitle: "입금대기", vc: vcCSDeposit)]
        
        
        menuViewController.register(nib: UINib(nibName: "ExchangeMenuCell", bundle: nil), forCellWithReuseIdentifier: "ExchangeMenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FAQFocusView", bundle: nil))
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        menuViewController.cellAlignment = .center
        
        getData()
    }
    
    fileprivate func initLayout(){
        boxLayout.layer.cornerRadius = 5
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
        backBtn2.isUserInteractionEnabled = true
        backBtn2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
        titleLayout.isUserInteractionEnabled = true
        titleLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
    }
    
    @objc func onClickEvent(sender:UITapGestureRecognizer){
        if(sender.view == backBtn || sender.view == backBtn2){
            stop()
        }else if(sender.view == titleLayout){
            showListPopup()
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
        super.viewWillAppear(animated)
        appInfo.setBtcInterface(self)
        appInfo.setKrwInterface(self)
    }
    
    fileprivate func getData(){
        holdingBtc.text = "0"
        holdingAmountText.text = "0"
        holdingIngText.text = "0"
        holdingAvailable.text = "0"
        coinCodeText1.text = coinCode
        coinCodeText2.text = coinCode
        coinCodeText3.text = coinCode
        coinNameText.text = coinName
        
        guard let account = vcExchange?.accounts?[coinCode!] as? [String:Any] else {
            stop()
            return
        }
        
        holdingBtc.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(vcExchange!.totalAsset))) + " BTC"
        holdingAmountText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(toDouble(account["balance"]))))
        holdingIngText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(toDouble(account["exchange_ing"]) + toDouble(account["trade_ing"]))))
        
        getCoinFee()
    }
    
    func goPage(_ page:Int){
        menuViewController.scroll(index: page, percent: 100, animated: true)
        contentViewController.scroll(to: page, animated: true)
        cellActive(page, menuViewController)
    }
    
    fileprivate func getCoinFee(){
        let request = CalculateFeeRequest()
        request.coinType = coinCode
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? CalculateFeeRequest{
            let response = CalculateFeeResponse(baseResponce: response)
            guard let account = vcExchange?.accounts?[coinCode!] as? [String:Any] else {
                return
            }
            
            DispatchQueue.main.async{ [self] in
                if let fee = response.getFee(){
                    var value = floor((toDouble(account["exchange_can"]) * 100000000) - (toDouble(fee) * 100000000)) / 100000000
                    if value < 0 {value = 0}
                    holdingAvailable.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(value)))
                }else{
                    holdingAvailable.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(toDouble(account["exchange_can"]))))
                }
            }
        }
    }
    
    fileprivate func showListPopup(){
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "VCExchangePopup") as? VCExchangePopup else {
            return
        }
        vc.vcExchange = self.vcExchange
        vc.curCoinCode = coinCode
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

//MARK: - Firebase
extension VCExchangeDetail:FirebaseInterface, ValueEventListener{
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
}


//MARK - PagingKit
extension VCExchangeDetail{
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

extension VCExchangeDetail: PagingMenuViewControllerDataSource, PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
        
        cellActive(page, viewController)
        
        if let v = dataSource[page].vc as? VCTabWithdraw{v.start()}
    }
    
    func cellActive(_ page: Int,_ viewController: PagingMenuViewController){
        for idx in 0 ..< dataSource.count{  // 선택된 셀 폰트 변경
            if let c = viewController.cellForItem(at:idx) as? ExchangeMenuCell{
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
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "ExchangeMenuCell", for: index) as! ExchangeMenuCell
        cell.titleText.text = dataSource[index].menuTitle
        if(0 == index){
            cell.titleText.textColor = UIColor(named: "C515151")
            cell.titleText.font = UIFont.boldSystemFont(ofSize: 14)
        }else{
            cell.titleText.textColor = UIColor(named: "CA1A1A1")
            cell.titleText.font = UIFont.systemFont(ofSize: 14)
        }
        
        
        
        return cell
    }
}

extension VCExchangeDetail:  PagingContentViewControllerDataSource, PagingContentViewControllerDelegate{
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


class ExchangeMenuCell: PagingMenuViewCell {
    @IBOutlet weak var titleText: UILabel!
}
