//
//  VCFAQ.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/12.
//

import UIKit
import Alamofire
import PagingKit
import WebKit


class VCFAQ: VCBase , UISearchBarDelegate {
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
 
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var query: UISearchBar!
    
    var allList:Array<FaqItem> = Array<FaqItem>()
    
    var viewAll = {() -> VCFAQAll in
           let vc = VCFAQAll()
            vc.WHERE = 0
            return vc
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
    var viewTrade = {() -> VCFAQAll in
           let vc = VCFAQAll()
            vc.WHERE = 3
            return vc
    }()
    
    var dataSource = Array<(menuTitle: String, vc: VCFAQAll)>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [(menuTitle: "전체", vc: viewAll), (menuTitle: "서비스 이용", vc: viewService), (menuTitle: "인증 및 보안", vc: viewSecurity), (menuTitle: "거래 및 출금", vc: viewTrade)]
        
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        
        query.delegate = self
        
        menuViewController.register(nib: UINib(nibName: "FAQMenuCell", bundle: nil), forCellWithReuseIdentifier: "FAQMenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FAQFocusView", bundle: nil))
        
        getData();
        menuViewController.reloadData()
        contentViewController.reloadData()
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
    
    fileprivate func getData(){
        let request:MypageFAQAllRequest = MypageFAQAllRequest()
        request.searchValue = ""
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? MypageFAQAllRequest{
            let data = MypageFAQAllResponse(baseResponce: response)
            let list = data.getList()
            if(list != nil){
                for item in list!{
                    let item = FaqItem(bg_idx: item["bg_idx"] as! Int, bg_cate_idx: item["bg_cate_idx"] as! Int, bg_title: item["bg_title"] as! String, bg_contents: item["bg_contents"] as! String, temp: false)
                    allList.append(item)
                }
            }
            search("")
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    fileprivate func search(_ s:String){
        viewAll.setData(allList, s)
        viewService.setData(allList, s)
        viewSecurity.setData(allList, s)
        viewTrade.setData(allList, s)
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(query.text!)
        view.endEditing(true)
    }
}

extension VCFAQ: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        var width = CGFloat(viewController.view.frame.size.width)
        width = width / CGFloat(dataSource.count)
        return width
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "FAQMenuCell", for: index) as! FAQMenuCell
        cell.titleLabel.text = dataSource[index].menuTitle
        return cell
    }
}

extension VCFAQ: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

extension VCFAQ: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].vc
    }
}

extension VCFAQ: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}

class FAQMenuCell: PagingMenuViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

struct FaqItem{
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
