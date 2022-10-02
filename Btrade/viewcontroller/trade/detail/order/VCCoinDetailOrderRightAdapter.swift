//
//  VCCoinDetailOrderRightAdapter.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/02.
//

import Foundation
import UIKit

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
