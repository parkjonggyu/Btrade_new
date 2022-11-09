//
//  VCAsset.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/09.
//

import Foundation
import UIKit
import PagingKit
import FirebaseDatabase

class VCAsset:VCBase, FirebaseInterface, ValueEventListener{
    var vcAssetStatus = {() -> VCAssetStatus in
        let sb = UIStoryboard.init(name:"Asset", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCAssetStatus") as? VCAssetStatus
        return vc!
    }()
    var vcFAssetRecord = {() -> VCAssetRecord in
        let sb = UIStoryboard.init(name:"Asset", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VCAssetRecord") as? VCAssetRecord
        return vc!
    }()
    
    var statusUpdate = true;
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var dataSource = Array<(menuTitle: String, vc: VCBase)>()
    
    var firebaseInterface:VCBase?
    var marketList:Array<[String:Any]>?
    var coinList:Array<[String:Any]>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vcAssetStatus.vcAsset = self
        vcFAssetRecord.vcAsset = self
        
        
        dataSource = [(menuTitle: "보유자산", vc: vcAssetStatus), (menuTitle: "거래내역", vc: vcFAssetRecord)]
        
        
        menuViewController.register(nib: UINib(nibName: "TradeMenuCell", bundle: nil), forCellWithReuseIdentifier: "TradeMenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "AssetFocusView", bundle: nil))
        
        
        menuViewController.reloadData()
        contentViewController.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("VCAsset viewWillDisappear")
        appInfo.setBtcInterface(nil)
        appInfo.setKrwInterface(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VCAsset viewDidAppear")
        appInfo.setBtcInterface(self)
        appInfo.setKrwInterface(self)
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
}


//MARK - PagingKit
extension VCAsset{
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

extension VCAsset: PagingMenuViewControllerDataSource, PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
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
        var width = CGFloat(viewController.view.frame.size.width)
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

extension VCAsset:  PagingContentViewControllerDataSource, PagingContentViewControllerDelegate{
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
