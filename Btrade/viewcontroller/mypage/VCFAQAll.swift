//
//  VCFAQAll.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/12.
//

import Foundation
import UIKit
import WebKit

class VCFAQAll: VCBase {
    let ALL:Int = 0;
    let SERVICE:Int = 1;
    let SECURITY:Int = 2;
    let TRADE:Int = 3;
    
    var WHERE:Int = 0;
    
    var tableView = UITableView()
    
    var viewList:Array<FaqItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        let nibName = UINib(nibName: "FAQCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "faqcell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset.left = 0
    }
    
    func setData(_ allList:Array<FaqItem> , _ query:String){
        viewList = Array<FaqItem>()
        for item in allList{
            if(query == ""){
                setItem(item)
            }else if((item.bg_title.contains(query))){
                setItem(item)
            }
        }
        if viewList != nil {
            self.tableView.reloadData()
        }
    }
    
    func setItem(_ item:FaqItem){
        if WHERE == 0 {
            viewList?.append(item)
            return
        }
        if item.bg_cate_idx == WHERE {
            viewList?.append(item)
            return
        }
    }
    
}

extension VCFAQAll: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "faqcell", for: indexPath) as? FAQCell else {
            return UITableViewCell()
        }
        let item = viewList?[indexPath.row]
        if(item?.bg_cate_idx == 0){
            cell.faq_type.text = ""
        }else if item?.bg_cate_idx == 1 {
            cell.faq_type.text = "[서비스 이용]"
        }else if item?.bg_cate_idx == 2 {
            cell.faq_type.text = "[인증 및 보안]"
        }else if item?.bg_cate_idx == 3 {
            cell.faq_type.text = "[거래 및 출금]"
        }
        
        cell.faq_title.text = item?.bg_title
        cell.selectionStyle = .none
        cell.upDownImage.image = UIImage(named: "text_field_bottom_arrow")
        var frame:CGRect = cell.webView.frame
        if(frame.size.height > 0){
            cell.webView.translatesAutoresizingMaskIntoConstraints = true
            frame.size.height = 0
            cell.webView.frame = frame
            viewList?[indexPath.row].changeSize(0);
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? FAQCell{
            if var item = self.viewList?[indexPath.row]{
                self.tableView.beginUpdates()
                if item.webViewSize! > 0{
                    item.changeSize(0)
                    viewList?[indexPath.row] = item
                    cell.upDownImage.image = UIImage(named: "text_field_bottom_arrow")
                    cell.webView.translatesAutoresizingMaskIntoConstraints = true
                    var frame:CGRect = cell.webView.frame
                    frame.size.height = 0
                    cell.webView.frame = frame
                    self.tableView.endUpdates()
                    
                }else{
                    cell.webView.configuration.preferences.javaScriptEnabled = true
                    var html = item.bg_contents
                    html = html.replacingOccurrences(of: " 14px", with: " 20px")
                    html = html.replacingOccurrences(of: " 11pt", with: " 20pt")
                    html = html.replacingOccurrences(of: " 14.6667px", with: " 20px")
                    html = html.replacingOccurrences(of: "line-height:", with: "")
                    html = html.trimmingCharacters(in: .whitespaces)
                    
                    print(html)
                    cell.webView.loadHTMLString(html, baseURL: nil)
                    cell.webView.navigationDelegate = self;
                    
                    viewList?[indexPath.row] = item
                    cell.upDownImage.image = UIImage(named: "text_field_top_arrow")
                    
                }
            }
        }
    }
}


extension VCFAQAll: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    var tag = 0
                    guard let _ = height else {
                        self.tableView.endUpdates()
                        return;
                    }
                    for _ in self.viewList!{
                        let indexPath = IndexPath(row: tag, section: 0)
                        if let cell = self.tableView.cellForRow(at: indexPath) as? FAQCell{
                            if cell.webView == webView {
                                if var item = self.viewList?[indexPath.row]{
                                    let size = (height as! CGFloat) * 0.4
                                    item.changeSize(Int(size))
                                    self.viewList?[indexPath.row] = item
                                    cell.webView.translatesAutoresizingMaskIntoConstraints = true
                                    var frame:CGRect = cell.webView.frame
                                    frame.size.height = size
                                    frame.size.width = cell.stackView.frame.size.width - 20
                                    cell.webView.frame = frame
                                    self.tableView.endUpdates()
                                    return;
                                }
                            }
                        }
                        tag += 1
                    }
                    self.tableView.endUpdates()
                })
            }
        })
    }
}

class FAQCell: UITableViewCell{
    @IBOutlet weak var faq_type: UILabel!
    @IBOutlet weak var faq_title: UILabel!
    @IBOutlet weak var upDownImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var webView: WKWebView!
}
