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
    var list:Array<[String:Any]>?
    @IBOutlet weak var bqContentText: WKWebView!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var cateText: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var replyLayout: UIView!
    @IBOutlet weak var qnaAddText: UILabel!
    @IBOutlet weak var answerDate: UILabel!
    @IBOutlet weak var answerContents: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        qnaAddText.isUserInteractionEnabled = true
        qnaAddText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goQnaAdd)))
     
        
        if(qna?.bq_confirm ?? "N" == "Y"){
            replyLayout.isHidden = true
        }
        
        setData()
        getData()
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
            if let list = data.getList(){
                self.list = list
                setData()
            }
        }
    }
    
    fileprivate func setData(){
        DispatchQueue.main.async {
            if let cate = self.qna?.bq_category{
                if(cate == "CA01"){self.cateText.text = "[보이스피싱 등 사고 접수 관련]"}
                else if(cate == "CA02"){self.cateText.text = "[회원가입/탈퇴/로그인 등 계정 관련]"}
                else if(cate == "CA03"){self.cateText.text = "[입출금 및 거래 관련]"}
                else if(cate == "CA04"){self.cateText.text = "[레벨 및 정보 변경 관련]"}
                else if(cate == "CA05"){self.cateText.text = "[홈페이지 관련 문의]"}
                else if(cate == "CA06"){self.cateText.text = "[기타 문의]"}
                else {self.cateText.text = ""}
            }
            if let title = self.qna?.bq_title{
                self.titleText.text = title
            }else{
                self.titleText.text = ""
            }
            if let date = self.qna?.reg_date{
                self.dateText.text = date
            }else{
                self.dateText.text = ""
            }
                        
            if self.list != nil && self.list!.count > 0{
                if let reply = self.list?[0]{
                    if var html = reply["content"] as? String{
                        self.replyLayout.isHidden = false
                        html = html.replacingOccurrences(of: " 14px", with: " 2.5rem")
                        html = html.replacingOccurrences(of: " 11pt", with: " 2.5rem")
                        html = html.replacingOccurrences(of: " 13.333px", with: " 2.5rem")
                        html = html.replacingOccurrences(of: "line-height:", with: "")
                        html = html.trimmingCharacters(in: .whitespaces)
                        html = "<div style=\"font-size: 2.5rem;\">" + html + "</div>"
                        self.answerContents.loadHTMLString(html, baseURL: nil)
                        self.answerContents.navigationDelegate = self;
                    }
                    
                    if let date = reply["reg_date"] as? String{
                        self.answerDate.text = date
                    }
                }else{
                    self.replyLayout.isHidden = true
                }
                
            }
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
}

extension VCQnaDetail: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    guard let _ = height else {
                        
                        return;
                    }
                    if self.bqContentText == webView {
                        let size = (height as! CGFloat) * 0.4
                        self.bqContentText.translatesAutoresizingMaskIntoConstraints = true
                        var frame:CGRect = self.bqContentText.frame
                        frame.size.height = size
                        frame.size.width = self.bqContentText.frame.size.width - 20
                        self.bqContentText.frame = frame
                        self.scrollView.updateContentSize()
                        return;
                    }
                    
                    if self.answerContents == webView {
                        let size = (height as! CGFloat) * 0.4
                        self.answerContents.translatesAutoresizingMaskIntoConstraints = true
                        var frame:CGRect = self.answerContents.frame
                        frame.size.height = size
                        frame.size.width = self.answerContents.frame.size.width - 20
                        self.answerContents.frame = frame
                        self.scrollView.updateContentSize()
                        return;
                    }
                    
                })
            }
        })
    }
}

extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height/2)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
}

