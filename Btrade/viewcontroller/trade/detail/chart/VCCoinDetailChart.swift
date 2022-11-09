//
//  VCCoinDetailChart.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/07.
//

import Foundation
import WebKit

class VCCoinDetailChart:VCBase,  WKNavigationDelegate{
    var vcDetail:VCCoinDetail?
    
    var page:String?
    weak var smsDelegate:WebResult?
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if let type = VCCoinDetail.coin?.coin_code, let market = VCCoinDetail.MARKETTYPE{
            page = BuildConfig.SERVER_URL + "m/trade/chart.do?coinType=" + type + "&marketType=" + market
        }
        
        let url = URL(string: page!)
        let request = URLRequest(url: url!)
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
    
}

extension VCCoinDetailChart: WKUIDelegate {
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }
}
