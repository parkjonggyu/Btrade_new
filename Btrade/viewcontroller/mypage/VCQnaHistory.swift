//
//  VCQnaHistory.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/17.
//

import Foundation
import Alamofire


class VCQnaHistory: VCBase {
    
    @IBOutlet weak var emptyText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIImageView!
    
    var mArray:Array<QnaItem> = Array<QnaItem>()
    var pageNo = 0
    
    var refresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        
        getData(pageNo)
        
        let nibName = UINib(nibName: "QNACell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "qnacell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorInset.left = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(refresh){
            refresh = false
            pageNo = 0
            mArray = Array<QnaItem>()
            getData(pageNo)
        }
    }
    
    fileprivate func getData(_ pageNo:Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            let request = MypageQNAHistoryRequest()
            request.page_no = String(pageNo)
            ApiFactory(apiResult: self, request: request).newThread()
        }
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? MypageQNAHistoryRequest{
            let data = MypageQNAHistoryResponse(baseResponce: response)
            if let list = data.getList() {
                for (index, item) in list.enumerated(){
                    let temp = QnaItem(bq_idx: item["bq_idx"] as! Int, mb_idx: item["mb_idx"] as! Int, bq_category: item["bq_category"] as! String, bq_category_nm: item["bq_category_nm"] as! String, bq_title: item["bq_title"] as! String, reg_date: item["reg_date"] as! String, bq_confirm: (item["bq_confirm"] as? String) ?? "",last:false)
                    print(temp)
                    mArray.append(temp)
                }
            }
            
            setList(data)
        }
    }
    
    fileprivate func setList(_ response:MypageQNAHistoryResponse){
        DispatchQueue.main.async {
            if self.mArray.count == 0{
                self.emptyText.text = "1:1 문의내역이 없습니다."
            }else{
                self.emptyText.text = ""
                self.emptyText.layer.isHidden = true
                self.pageNo = response.getpageNo()
                if(self.mArray.count < response.getTotalCount()){
                    self.mArray[self.mArray.endIndex - 1].setLast(true)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func onError(e: AFError, method: String) {
        
    }
    
    @IBAction func goQnaPage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "qnavc")
        self.navigationController?.pushViewController(vc!, animated: true)
        return
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension VCQnaHistory: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "qnacell", for: indexPath) as? QNACell else {
            return UITableViewCell()
        }
        if let item = mArray[indexPath.row] as? QnaItem{
            cell.title.text = item.bq_title
            cell.category.text = "[" + item.bq_category_nm + "]"
            cell.date.text = item.reg_date
            cell.selectionStyle = .none
            if item.bq_confirm == "Y"{
                cell.answered.text = "답변완료"
                cell.answered.textColor = hexStringToUIColor(hex: "#0068B7")
            }else if item.bq_confirm == "R"{
                cell.answered.text = "반려"
                cell.answered.textColor = hexStringToUIColor(hex: "#0068B7")
            }else{
                cell.answered.text = "답변대기"
                cell.answered.textColor = hexStringToUIColor(hex: "#515151")
            }
            if(item.last){
                mArray[indexPath.row].setLast(false)
                getData(self.pageNo + 1)
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "qnadetailvc") as? VCQnaDetail{
            vc.qna = mArray[indexPath.row]
            vc.vcQnaHistory = self
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
    }
}


struct QnaItem{
    var bq_idx:Int
    var mb_idx:Int
    var bq_category:String
    var bq_category_nm:String
    var bq_title:String
    var reg_date:String
    var bq_confirm:String
    var last:Bool
    
    mutating func setLast(_ bool:Bool){
        last = bool
    }
}

class QNACell: UITableViewCell{
    @IBOutlet weak var answered: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var category: UILabel!
}
