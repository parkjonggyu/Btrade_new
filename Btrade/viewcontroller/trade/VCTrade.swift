//
//  VCTrade.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/11.
//

import UIKit
import Alamofire
import PagingKit

class VCTrade: VCBase {
    var vcBtc = {() -> VCTradeBTC in
        let sb = UIStoryboard.init(name:"Trade", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "tradebtcvc") as? VCTradeBTC
        return vc!
    }()
    var viewService = {() -> VCFAQAll in
           let vc = VCFAQAll()
            vc.WHERE = 1
            return vc
    }()
    var viewSecurity = {() -> VCFAQAll in
           let vc = VCFAQAll()
            vc.WHERE = 2
            return vc
    }()
    
    var allList:Array<TradeItem> = Array<TradeItem>()
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var dataSource = Array<(menuTitle: String, vc: VCBase)>()
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [(menuTitle: "BTC", vc: vcBtc), (menuTitle: "즐겨찾기", vc: viewService), (menuTitle: "보유코인", vc: viewSecurity)]
        
        
        
        menuViewController.register(nib: UINib(nibName: "TradeMenuCell", bundle: nil), forCellWithReuseIdentifier: "TradeMenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FAQFocusView", bundle: nil))
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        getData()
    }
    
    fileprivate func getData(){
        vcBtc.setArrayList(appInfo.COINLIST)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self
        }
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
    
    @IBAction func clickedSearch(_ sender: Any) {
        let SIZE = 150.0
        self.searchField.translatesAutoresizingMaskIntoConstraints = true
        self.searchBtn.translatesAutoresizingMaskIntoConstraints = true
        if(searchField.frame.size.width <= (SIZE / 2)){
            searchBtn.frame.origin.x = searchBtn.frame.origin.x - SIZE
            searchField.frame.origin.x = searchField.frame.origin.x - SIZE
            searchField.frame.size.width = searchField.frame.size.width + SIZE
            searchField.becomeFirstResponder()
        }else{
            searchBtn.frame.origin.x = searchBtn.frame.origin.x + SIZE
            searchField.frame.origin.x = searchField.frame.origin.x + SIZE
            searchField.frame.size.width = searchField.frame.size.width - SIZE
            searchField.text = ""
        }
    }
}

extension VCTrade: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        var width = CGFloat(viewController.view.frame.size.width)
        width = width / CGFloat(dataSource.count)
        return width
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "TradeMenuCell", for: index) as! TradeMenuCell
        cell.titleText.text = dataSource[index].menuTitle
        return cell
    }
}

extension VCTrade: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

extension VCTrade: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].vc
    }
}

extension VCTrade: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
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
}
