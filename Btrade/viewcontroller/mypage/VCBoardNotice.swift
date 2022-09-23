//
//  VCBoardNotice.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/11.
//

import Foundation
import Alamofire


class VCBoardNotice: VCBase ,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var query: UISearchBar!
    @IBOutlet weak var noticeList: UITableView!
    
    @IBOutlet weak var backBtn1: UIImageView!
    
    
    var allList:Array<Notice>?
    var viewList:Array<Notice>?
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn1.isUserInteractionEnabled = true
        backBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        
        query.delegate = self
        getData()
        
    }
    
    fileprivate func getData(){
        let request:BoardNoticeRequest = BoardNoticeRequest()
        request.searchValue = ""
        ApiFactory(apiResult: self, request: request).netThread()
        noticeList.dataSource = self
        noticeList.delegate = self
        noticeList.separatorInset.left = 0
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? BoardNoticeRequest{
            let data = BoardNoticeResponse(baseResponce: response)
            allList = Array<Notice>()
            let importantList = data.getImportantList()
            let list = data.getList()
            var idx = 0
            if(importantList != nil){
                for item in importantList!{
                    let notice = Notice(bn_idx: item["bn_idx"] as? Int, bn_title: item["bn_title"] as? String, bn_contents: item["bn_contents"] as? String, reg_date: item["reg_date"] as? String, mod_date: item["mod_date"] as? String, searchValue: item["searchValue"] as? String, important: true ,sequence:idx)
                    allList?.append(notice)
                    idx += 1
                }
            }
            if(list != nil){
                for item in list!{
                    let notice = Notice(bn_idx: item["bn_idx"] as? Int, bn_title: item["bn_title"] as? String, bn_contents: item["bn_contents"] as? String, reg_date: item["reg_date"] as? String, mod_date: item["mod_date"] as? String, searchValue: item["searchValue"] as? String, important: true , sequence:idx)
                        allList?.append(notice)
                        idx += 1
                }
            }
            search("")
        }
    }
    
    fileprivate func search(_ s:String){
        viewList = Array<Notice>()
        for notice in allList!{
            if(s == ""){
                viewList?.append(notice)
            }else if((notice.bn_title!.contains(s))){
                viewList?.append(notice)
            }
        }
        if viewList != nil {
            self.noticeList.reloadData()
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "boardcell", for: indexPath) as? BoardCell else {
            return UITableViewCell()
        }
        let item = viewList?[indexPath.row]
        cell.titleText.text = item?.bn_title
        cell.dateText.text = item?.reg_date
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "boardnoticedetailvc") as? VCBoardNoticeDetail else {
            return
        }
        vc.sequence = viewList?[indexPath.row].sequence ?? -1
        vc.array = allList
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(query.text!)
        view.endEditing(true)
    }
}

class BoardCell: UITableViewCell{
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var dateText: UILabel!
}

struct Notice{
    var bn_idx:Int?
    var bn_title:String?
    var bn_contents:String?
    var reg_date:String?
    var mod_date:String?
    var searchValue:String?
    var important:Bool
    var sequence:Int = -1;
}
