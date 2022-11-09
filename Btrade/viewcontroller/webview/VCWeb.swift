//
//  VCWeb.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/21.
//

import Foundation
import WebKit
import UIKit

class VCWeb:VCBase,  WKNavigationDelegate, WKScriptMessageHandler{
    
    
    var page:String?
    var titleString:String?
    weak var smsDelegate:WebResult?
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let s = titleString{
            titleText.text = s
        }
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
    }
    
    @objc func onClickEvent(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            stop()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if page == nil{
            stop()
            return
        }
        print("page : " + page!)
        let url = URL(string: page!)
        let request = URLRequest(url: url!)
        webView.configuration.websiteDataStore = setCookie(url!)
        webView.configuration.userContentController.add(self, name:"btrade")
        webView.configuration.preferences.javaScriptEnabled = true
        webView.load(request)
    }
    
    func setCookie(_ url:URL) -> WKWebsiteDataStore{
        let wkDataStore = WKWebsiteDataStore.nonPersistent()
        if let sharedCookies:Array<HTTPCookie> = HTTPCookieStorage.shared.cookies(for: url){
            for cookies in sharedCookies {
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookies)
                wkDataStore.httpCookieStore.setCookie(cookies)
            }
        }
        return wkDataStore
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("page !!!!!!!!!!!!!!!")
        print(message)
        if message.name == "btrade"{
            if let data = convertToDictionary(text: message.body as! String){
                smsDelegate?.result(data)
            }
            stop()
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func stop(){
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https"{
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
    }
}

extension VCWeb: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
