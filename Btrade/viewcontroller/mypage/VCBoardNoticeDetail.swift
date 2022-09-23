//
//  VCBoardNoticeDetail.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/08.
//

import Foundation
import Alamofire
import WebKit


class VCBoardNoticeDetail: VCBase, WKNavigationDelegate {
    var sequence:Int = -1;
    var array:Array<Notice>?
    var each:Bool = false
    
    
    @IBOutlet weak var backBtn: UILabel!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var nextNotice: UILabel!
    @IBOutlet weak var previousNotice: UILabel!
    
    @IBOutlet weak var allStack: UIStackView!
    @IBOutlet weak var contentsLine: UILabel!
    
    @IBOutlet weak var backBtn1: UIImageView!
    @IBOutlet weak var nextLayout: UIStackView!
    @IBOutlet weak var preLayout: UIStackView!
    @IBOutlet weak var bntList: UIButton!
    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(each){
            bntList.setTitle("확인", for: .normal)
        }else{
            bntList.setTitle("목록", for: .normal)
        }
        
        backBtn1.isUserInteractionEnabled = true
        backBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        
        nextNotice.isUserInteractionEnabled = true
        previousNotice.isUserInteractionEnabled = true
        
        webView.navigationDelegate = self;
        webView.configuration.preferences.javaScriptEnabled = true
        setData()
    }
    
    fileprivate func setData(){
        if(array == nil || sequence < 0){
            stop()
            return
        }
        
        var pre:Notice? = nil
        var current:Notice? = nil
        var next:Notice? = nil
        
        if(sequence < (array?.count)! - 1){pre = array?[sequence + 1]}
        if(sequence > 0){next = array?[sequence - 1]}
        current = array?[sequence]
        
        
        ////////////////////// current
        
        titleText.text = current?.bn_title
        if let date = current?.mod_date{
            dateText.text = date
        }else{
            dateText.text = current?.reg_date
        }
        if var html = current?.bn_contents{
            
            html = html.replacingOccurrences(of: " 11pt", with: " 20pt")
            html = html.replacingOccurrences(of: "line-height:", with: "")
            print(html)
            self.webView.loadHTMLString(html, baseURL: nil)
        }
        
        
        
        // -------- pre
        if(pre != nil){
            previousNotice.text = pre?.bn_title
            previousNotice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onclicked)))
        }else{
            previousNotice.text = "이전 글이 없습니다."
        }
        
        // -------- next
        if(next != nil){
            nextNotice.text = next?.bn_title
            nextNotice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onclicked)))
        }else{
            nextNotice.text = "다음 글이 없습니다."
        }
        
    }
    
    @objc func onclicked(sender:UITapGestureRecognizer){
        if(sender.view == nextNotice){
            if(sequence > 0){
                sequence -= 1
                setData()
            }
        }else if(sender.view == previousNotice){
            if(sequence < (array?.count)! - 1){
                sequence += 1
                setData()
            }
        }
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        stop()
    }
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    
                    
                            
                })
            }
        })
    }
}
