//
//  VCCoinDetailOrderRight.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/01.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCCoinDetailOrderRight: VCBase{
    var adapter:VCCoinDetailOrderRightAdapter?
    
    @IBOutlet weak var item1Back: UIView!
    @IBOutlet weak var item1Text: UILabel!
    
    
    @IBOutlet weak var item2Back: UIView!
    @IBOutlet weak var item2Text: UILabel!
    
    @IBOutlet weak var item3Back: UIView!
    @IBOutlet weak var item3Text: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedItem(0)
        
        item1Back.isUserInteractionEnabled = true
        item1Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item2Back.isUserInteractionEnabled = true
        item2Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item3Back.isUserInteractionEnabled = true
        item3Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item1Text.isUserInteractionEnabled = true
        item1Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item2Text.isUserInteractionEnabled = true
        item2Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item3Text.isUserInteractionEnabled = true
        item3Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
    }
    
    
    @objc func objcItem(sender:UITapGestureRecognizer){
        if(sender.view == item1Back || sender.view == item1Text){
            adapter?.setViewcontrollersFromIndex(index: 0)
        }else if(sender.view == item2Back || sender.view == item2Text){
            adapter?.setViewcontrollersFromIndex(index: 1)
        }else if(sender.view == item3Back || sender.view == item3Text){
            adapter?.setViewcontrollersFromIndex(index: 2)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VCCoinDetailOrderRightAdapter {
            adapter = vc
            adapter?.completeHandler = { idx in
                self.selectedItem(idx)
            }
        }
    }
    
    fileprivate func selectedItem(_ idx:Int){
        initItem()
        
        if(idx == 0){
            item1Back.backgroundColor = .white
            item1Text.textColor = UIColor(named: "HogaPriceRed")
        }else if(idx == 1){
            item2Back.backgroundColor = .white
            item2Text.textColor = UIColor(named: "HogaPriceBlue")
        }else if(idx == 2){
            item3Back.backgroundColor = .white
            item3Text.textColor = UIColor(named: "HogaPriceGray")
        }
    }
    
    fileprivate func initItem(){
        item1Back.backgroundColor = UIColor(named: "OrderItemBack")
        item2Back.backgroundColor = UIColor(named: "OrderItemBack")
        item3Back.backgroundColor = UIColor(named: "OrderItemBack")
        item1Text.textColor = UIColor(named: "OrderItemText")
        item2Text.textColor = UIColor(named: "OrderItemText")
        item3Text.textColor = UIColor(named: "OrderItemText")
    }
}

extension VCCoinDetailOrderRight: FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        if let sender = adapter?.getCurrentView() as? FirebaseInterface{
            sender.onDataChange(market: market)
        }
    
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        if let sender = adapter?.getCurrentView() as? ValueEventListener{
            sender.onDataChange(snapshot: snapshot)
        }
    }
    
    func setPrice(_ price:String){
        if let view = adapter?.getCurrentView(){
            if let a = view as? VCCoinDetailOrderBuy{
                a.setPrice(price)
            }
            if let b = view as? VCCoinDetailOrderSell{
                b.setPrice(price)
            }
        }
    }
}


class VCCoinDetailOrderRightAdapter: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    var completeHandler : ((Int)->())?
        
    let viewsList : [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Trade", bundle: nil)
       
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "VCCoinDetailOrderBuy")
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "VCCoinDetailOrderSell")
        let vc3 = storyBoard.instantiateViewController(withIdentifier: "VCCoinDetailOrderMyTrade")
        return [vc1, vc2, vc3]
    }()


    var currentIndex : Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }

    func getCurrentView() -> UIViewController?{
        return viewsList[currentIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstvc = viewsList.first {
            self.setViewControllers([firstvc], direction: .forward, animated: false, completion: nil)
        }
        
        stopScroll()
    }

    fileprivate func stopScroll(){
        for view in self.view.subviews{
            if let subView = view as? UIScrollView{
                subView.isScrollEnabled = false
            }
        }
    }
    
    func setViewcontrollersFromIndex(index : Int){
        if(currentIndex == index){return}
        if index < 0 && index >= viewsList.count {return }
        self.setViewControllers([viewsList[index]], direction: .forward, animated: false, completion: nil)
        completeHandler?(currentIndex)
    }

     func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            completeHandler?(currentIndex)
        }
    }


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else {return nil}
        let previousIndex = index - 1
        if previousIndex < 0 { return nil}
        return viewsList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else {return nil}
        let nextIndex = index + 1
        if nextIndex == viewsList.count { return nil}
        return viewsList[nextIndex]
    }
}
