//
//  VCTabWithdraw.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/18.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCTabWithdraw:VCBase {
    var vcExchangeDetail:VCExchangeDetail?
    
    
    var adapter:VCTabWithdrawAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setView(_ index:Int){
        adapter?.setViewcontrollersFromIndex(index: index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VCTabWithdrawAdapter {
            adapter = vc
            vc.setSuperView(self)
            adapter?.completeHandler = { idx in
                
            }
        }
    }
    
    func start(){
        adapter?.initLayout()
        if let v = adapter?.getCurrentView() as? VCTabWithdrawStepOne{
            v.start()
        }
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
    
    func sendData(_ data:[String:Any?]){
        if let v = adapter?.viewsList[1] as? VCTabWithdrawStepTwo{
            v.sendData(data)
        }
    }
}

//MARK: - Firebase
extension VCTabWithdraw: FirebaseInterface, ValueEventListener{
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
}


//MARK: - Adapter
class VCTabWithdrawAdapter: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    var cvTabWithdraw:VCTabWithdraw?
    var completeHandler : ((Int)->())?
        
    let viewsList : [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Exchange", bundle: nil)
       
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "VCTabWithdrawStepOne")
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "VCTabWithdrawStepTwo")
        let vc3 = storyBoard.instantiateViewController(withIdentifier: "VCTabWithdrawAuth")
        
        
        return [vc1, vc2, vc3]
    }()
    
    var currentIndex : Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }

    func setSuperView(_ v:VCTabWithdraw){
        cvTabWithdraw = v
        if let vv = viewsList[0] as? VCTabWithdrawStepOne{vv.vcTabWithdraw = v}
        if let vv = viewsList[1] as? VCTabWithdrawStepTwo{vv.vcTabWithdraw = v}
        if let vv = viewsList[2] as? VCTabWithdrawAuth{vv.vcTabWithdraw = v}
    }
    
    func getCurrentView() -> UIViewController?{
        return viewsList[currentIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        initLayout()
        stopScroll()
    }

    func initLayout(){
        if let vc = cvTabWithdraw{
            if let memberInfo = vc.appInfo.memberInfo{
                var level = CoinUtils.getlevel(memberInfo)
                if level < 3{
                    self.setViewControllers([viewsList[2]], direction: .forward, animated: false, completion: nil)
                }else{
                    self.setViewControllers([viewsList[0]], direction: .forward, animated: false, completion: nil)
                }
                return
            }
        }
        
        if let firstvc = viewsList.first {
            self.setViewControllers([firstvc], direction: .forward, animated: false, completion: nil)
        }
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
        
        if(index == 1){if let vv = viewsList[1] as? VCTabWithdrawStepTwo{vv.initLayout()}}
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
