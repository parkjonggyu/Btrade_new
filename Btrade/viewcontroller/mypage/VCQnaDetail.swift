//
//  VCQnaDetail.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/23.
//

import Foundation
import Alamofire
import WebKit


class VCQnaDetail: VCBase {
    var vcQnaHistory:VCQnaHistory?
    var qna:QnaItem?
    var mArray:Array<DetailItem> = Array<DetailItem>()
    var firstQuestion:[String:Any]?
    var conversation:[String:Any]?
    @IBOutlet weak var mList: UITableView!
    @IBOutlet weak var backBtn: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
     
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        mList.separatorStyle = .none
        
        
        initData()
        setData()
        getData()
    }
    
    fileprivate func initData(){
        mArray.append(DetailItem(cate: toString(qna?.bq_category ?? ""), date: toString(qna?.reg_date ?? ""), comfirm: toString(qna?.bq_confirm ?? ""), title: toString(qna?.bq_title ?? ""), idx: toString(qna?.bq_idx ?? "")))
    }
    
    fileprivate func getData(){
        let request = MypageQNADetailRequest()
        if let idx = qna?.bq_idx{
            request.bq_idx = String(idx)
        }
        ApiFactory(apiResult: self, request: request).newThread()
        
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? MypageQNADetailRequest{
            let data = MypageQNADetailResponse(baseResponce: response)
            if let first = data.getFirstQuestion(){
                firstQuestion = first
            }
            if let c = data.getConversation(){
                conversation = c
            }
            
            
            if let list = data.getList(){
                for item in list{
                    let d = DetailItem(cate: toString(item["type"] ?? ""), date: toString(item["reg_date"] ?? ""), comfirm: toString(item["file_path"] ?? ""), title: toString(item["content"] ?? ""), idx: toString(item["bq_idx"] ?? ""))
                    mArray.append(d)
                }
                setData()
            }
        }
    }
    
    fileprivate func setData(){
        DispatchQueue.main.async {
            self.mList.reloadData()
        }
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goQnaAdd(sender:UITapGestureRecognizer){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "qnaaddvc") as? VCQnaAdd{
            if let idx = qna?.bq_idx{
                vc.bq_idx = String(idx)
            }else{
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
    fileprivate func toString(_ data:Any) -> String{
        if let a = data as? String{
            return a
        }
        if let a = data as? Int64{
            return String(a)
        }
        return ""
    }
}

struct DetailItem{
    let cate:String?
    let date:String?
    let comfirm:String?
    let title:String?
    let idx:String?
}

class QnaDetailCell: UITableViewCell{
    
    @IBOutlet weak var layout0: UIStackView!
    @IBOutlet weak var cateText: UILabel!
    @IBOutlet weak var bqContentText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    
    //답변
    @IBOutlet weak var layout1: UIStackView!
    @IBOutlet weak var qnaAddText: UILabel!
    @IBOutlet weak var answerDate: UILabel!
    @IBOutlet weak var answerContents: UILabel!
    
    
    //추가문의
    @IBOutlet weak var layout2: UIStackView!
    @IBOutlet weak var addquestionDate: UILabel!
    @IBOutlet weak var addquestionText: UILabel!
    
    
    //추가 답변
    @IBOutlet weak var layout3: UIStackView!
    @IBOutlet weak var addanswerDate: UILabel!
    @IBOutlet weak var addanswerText: UILabel!
    @IBOutlet weak var qnaAddText2: UILabel!
}

extension VCQnaDetail: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QnaDetailCell", for: indexPath) as? QnaDetailCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        if let item = mArray[indexPath.row] as? DetailItem{
            cell.layout0.isHidden = true
            cell.layout1.isHidden = true
            cell.layout2.isHidden = true
            cell.layout3.isHidden = true
            if(indexPath.row == 0){
                cell.layout0.isHidden = false
                if let cate = item.cate{
                    if(cate == "CA01"){cell.cateText.text = "[보이스피싱 등 사고 접수 관련]"}
                    else if(cate == "CA02"){cell.cateText.text = "[회원가입/탈퇴/로그인 등 계정 관련]"}
                    else if(cate == "CA03"){cell.cateText.text = "[입출금 및 거래 관련]"}
                    else if(cate == "CA04"){cell.cateText.text = "[레벨 및 정보 변경 관련]"}
                    else if(cate == "CA05"){cell.cateText.text = "[홈페이지 관련 문의]"}
                    else if(cate == "CA06"){cell.cateText.text = "[기타 문의]"}
                    else {cell.cateText.text = ""}
                }
                
                if let date = self.conversation?["reg_date"] as? String{
                    cell.dateText.text = date
                }else{
                    cell.dateText.text = ""
                }
                if let title = item.title{
                    cell.titleText.text = title
                }else{
                    cell.titleText.text = ""
                }
                
                if let html = self.firstQuestion?["content"] as? String{
                    cell.bqContentText.text = html
                    cell.bqContentText.layoutIfNeeded()
                }
                
                if(item.comfirm == "R"){
                    if let date = self.conversation?["mod_date"] as? String{
                        cell.layout1.isHidden = false
                        cell.answerDate.text = date
                        cell.answerContents.text = "개인정보 기입으로 반려 처리 되었습니다."
                        cell.answerContents.layoutIfNeeded()
                    }else{
                        cell.answerDate.text = ""
                    }
                    
                }
            }
            
            
            if(indexPath.row == 1 && item.cate == "answer"){
                cell.layout1.isHidden = false
                if let date = item.date{
                    cell.answerDate.text = date
                }else{
                    cell.answerDate.text = ""
                }
                if let content = item.title{
                    cell.answerContents.text = content
                }else{
                    cell.answerContents.text = ""
                }
            }else if(indexPath.row > 0){
                if(item.cate == "answer"){
                    cell.layout3.isHidden = false
                    if let date = item.date{
                        cell.addanswerDate.text = date
                    }else{
                        cell.addanswerDate.text = ""
                    }
                    if let content = item.title{
                        cell.addanswerText.text = content
                    }else{
                        cell.addanswerText.text = ""
                    }
                }else{
                    cell.layout2.isHidden = false
                    if let date = item.date{
                        cell.addquestionDate.text = date
                    }else{
                        cell.addquestionDate.text = ""
                    }
                    if let content = item.title{
                        cell.addquestionText.text = content
                    }else{
                        cell.addquestionText.text = ""
                    }
                }
            }
        }
        return cell
    }
}
